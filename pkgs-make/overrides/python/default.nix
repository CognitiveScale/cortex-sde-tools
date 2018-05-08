pkgs: self: super:

if super.isPy3k
then
    {
        # ML packages
        annoy = (import ./annoy) pkgs self super;
        backoff = (import ./backoff) pkgs self super;
        bokeh = (import ./bokeh) pkgs self super;
        cdap-auth-client = (import ./cdap-auth-client) pkgs self super;
        cortex-client-4 = (import ./cortex-client-4) pkgs self super;
        cortex-client-5 = (import ./cortex-client-5) pkgs self super;
        editdistance = (import ./editdistance) pkgs self super;
        en_core_web_md = (import ./en_core_web_md) pkgs self super;
        gensim = (import ./gensim) pkgs self super;
        geopy = (import ./geopy) pkgs self super;
        imbalanced-learn = (import ./imbalanced-learn) pkgs self super;
        implicit = (import ./implicit) pkgs self super;
        lda = (import ./lda) pkgs self super;
        lime = (import ./lime) pkgs self super;
        marshmallow-oneofschema = (import ./marshmallow-oneofschema) pkgs self super;
        ortools = (import ./ortools) pkgs self super;
        plotly = (import ./plotly) pkgs self super;
        pyldavis = (import ./pyldavis) pkgs self super;
        python-igraph = (import ./python-igraph) pkgs self super;
        pytorch = (import ./pytorch) pkgs self super;
        pywavelets = (import ./pywavelets) pkgs self super;
        scikit-image = (import ./scikit-image) pkgs self super;
        scikit-multilearn = (import ./scikit-multilearn) pkgs self super;
        spacy = (import ./spacy) pkgs self super;
        torchfile = (import ./torchfile) pkgs self super;
        torchtext = (import ./torchtext) pkgs self super;
        torchvision = (import ./torchvision) pkgs self super;
        visdom = (import ./visdom) pkgs self super;

        # Overridden dependencies
        avro = (import ./avro) pkgs self super;
        cytoolz = (import ./cytoolz) pkgs self super;
        hexdump = (import ./hexdump) pkgs self super;
        liac-arff = (import ./liac-arff) pkgs self super;
        mocket = (import ./mocket) pkgs self super;
        pathlib = (import ./pathlib) pkgs self super;
        psycopg2 = (import ./psycopg2) pkgs self super;
        smart_open = (import ./smart_open) pkgs self super;
    }
else
    {}
