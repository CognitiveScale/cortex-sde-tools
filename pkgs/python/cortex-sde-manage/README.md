# c12e-ml-psa


## Run the solver

From the app directory, enter nix-shell and run:

``` bash
c12e-ml-psa --input 'path/to/json/file'
```


## Model formulation

### Goal

For each appointment in an order, find the optimal:
1. Time slot to schedule it at
2. Resource to schedule it with

Each json file corresponds to a single order. 

Each order contains n appointments 
that need to be scheduled. 

### Appointments

There are 8 appointment types:
* **FOLLOW UP** -- This is the anchor appointment for the order. Every order will
  have one (and only one) follow up. All other appointments must be
  scheduled PRIOR to the follow up. It is the only appointment that is
  scheduled with a person resource (physician) instead of a machine or
  room.
* **CT** -- CT scan
* **CT PREP** -- Each CT scan needs a prep appointment to be scheduled
  immediately before. Note that prep appointments are *NOT* passed in
  the json file. In other words, when a CT scan is requested in an
  order, a prep appointment will *NOT* explicitly be listed in the
  **'orders'** key. However, the model is still expected to return a
  suggested start time and resource for a prep appointment. The
  cleanAppts.py file creates a prep appointment for each CT in an
  order, which will then be passed to the solver (along with the other
  appointments) for scheduling.
* **MRI** -- MRI
* **MRI PREP** -- Same as CT PREP, but for MRI appointments
* **US** -- Ultrasound
* **XRAY** -- Xray, note that if multiple xrays are requested in an
  order, they must all be scheduled into ONE 15 minute time slot. In
  other words, if an order requests 3 xrays, the solver will only
  return a single 15 minute slot and resource for all of them. The
  cleanAppts.py file will perform this collapsing, and the solver will
  consider all xrays to be a single appointment.
* **LAB** -- Same as xray, but for lab appointments.

In addition to appointment type, each appointment has a duration, and a set of possible 
resources that it can be scheduled to. A resource is identified by a unique ID, and,
depending on the appointment type, can refer to a machine, physician,
or room. 

The appointments that need to be scheduled are passed in the
json file under the key **'orders'**. The value for the key
**'orders'** is a list, where each element is a dictionary containing
information (visit type, expected date, provider, name) for an
appointment.

To figure out what resources an appointment can be scheduled to, you
must map the appointment's visit type to a pool, which maps to a set
of resources. This mapping can be found in the spreadsheets contained
in the data directory. An appointment's visit type can be found under
the **'orders'** key in the json file.

### Solver variables

For each appointment, the model will solve for the following variables:
* *r* -- resource to schedule the appointment with
* *x* -- start time for the appointment
* *d* -- department that the resource belongs to
* *f* -- facility where the resource is located
* *z* -- zone that the facility belongs to

*f*,*z*, and *d* are intermediate variables for the solver, and are
used only for the formulation of some of the constraints. Once *r* has
been determined, you get *f*, *z*, and *d* for free, because when you
know the resource, you can figure out what department and facility it
is in. And when you know the facility, you can figure out the
zone. All of these mappings can be found in the data directory.

### Expected date

Each order has an expectedDate, which is provided by the Physican who
placed the order. This expectedDate is found in the FOLLOW UP entry in
the **'orders'** key in the json file. Note that the other anciliary
appointments (CT, Labs, etc) might have a DIFFERENT expectedDate from
the FOLLOW UP appointment. Ignore these alternate dates, and take only
the FOLLOW UP expectedDate as ground truth.

### Start date

For each order, there will be a startDate, which refers to the
earliest day that slots are provided. This startDate will be max 14
days prior to the expectedDate, but could be as small as one or two
days prior to the expectedDate. The startDate will be determined by
the solutions team when they make the call to MDA's APIs. While this
startDate varies between orders in calendar day and distance from the
expectedDate, it will always serve as a reference point for
determining units of time as you will see in the section below.

### Time units

Time in this PSA world exists in five minute intervals, so there are
288 time steps in a single day.  EXAMPLE: If the solver returns 115 as
the start time for an appointment, that would refer to the 115th five
minute time step relative to the startDate. If the startDate is
datetime.datetime(2018, 12, 5, 0, 0), then 115 corresponds to
datetime.datetime(2018, 12, 5, 9, 35).

In the file cleanRes.py, you will find two handy functions (mapTime
and unmapTime) that map values from real world time units to PSA time
units, and vice versa.

### Constraints

There are numerous rules that we must adhere to when scheduling. Most
of these rules are represented as constraints, which are passed to the
solver. Some examples are:
- Patient should not be scheduled for same exam +/- 22 days
- MRI Abdomen and MRI Pelvis studies should be scheduled to same
  resource with back to back slots
- Non-combined CTs must be scheduled 24 hours apart from the ending of scan time.
- There should be a minimum of 2 hours from scheduled lab appointments
  and the patient’s clinical appointment.

### Patient preferences

Patients are being asked to fill out a survey when they come to MDA,
in order to capture their preferences for when and where they would
like to have their appintments. The day(s) of the week that they want
to come to MDA, as well the facilities they prefer, and how many days
they want the appointments spread over are all found in the key
**'patientPreference'** in the json file. Preferences are considered
hard constraints in the model, so if a patient is too selective, the
model might be unable to find a schedule. In this case, the UI
provides the scheduler with the option to change the preferences and
refresh for a new schedule. Refreshing will call the solver again, but
with a NEW json file that has different patient preferences.

### Optimization objective

In addition to constraints, the model also has an optimization
objective. This objective has two components:

1. Schedule the follow up appointment start time as close as possible
   (given the physician availability and the constraints) to the
   expectedDate.
2. Schedule the start time for all other appointments as close as
   possible (given resource availability and the constraints) to the
   follow up appointment's start time.


## File details

The main function for this module is psaSolver in the runSolver.py
file. This function is called by the cli.py file, which creates the
command line interface for this module.

The runSolver function takes as input a json string, which contains
the patient's preferences, the patient's previous appointments, the
appointments that need to be scheduled for this order, and all the
possible slots available for these appointments. The files
cleanAppts.py, cleanRes.py, and cleanPref.py contain functions that
take the relevant information from the json file, and format it
properly for the solver. After formatting the data, the runSolver
function creates the solver, then finds a solution, and returns that
solution as a json string.

**cleanAppts.py** Formats the appointments into a nice dataframe. In
addition to formatting, it cleans the data by collapsing labs,
collapsing xrays, creating CT and MRI prep appointments, collapsing
any CT or MRI appointments that should be schduled in a single slot or
back to back slots (per insurance or hospital rules), and checking a
patient's previous appointments to make sure we are not scheduling
overlapping appointments within 22 days.

**cleanRes.py** Formats the available slots into a nice
dataframe. Slot info is found in the **'slotMap'** key in the json
file. The value is a dictionary, where each key is a visit type. Each
visit type maps to a list with all of the available slots for all of
the possible resources for appointments with that visit type. Each row
in the data frame created by the function createBlockDF represents a
chunk of consecutive five minute intervals that a particular resource
is available for.

**cleanPref.py** Formats the patient preferences and puts them into a
dictionary. The availability key shows all of the five minute
intervals that a patient is available, so the solution must be
scheduled at one of those time slots.

**config.py**
Misc functions

**model.py** Contains all of the model constraints, which are called
in the function createSolver in runSolver.py
