let

    pkgs-make = (import ../pkgs-make) {};

    pkgs = pkgs-make (import ./.);

    pkgsOverrides = with pkgs.nixpkgs; {
        inherit
           cudnn_cudatoolkit9
           nccl_cudatoolkit9
           rdkafka
           igraph;
    };

    pkgsPy = with pkgs.nixpkgs.pythonPackages; {
        inherit

            # ML libraries
            annoy
            backoff
            bokeh
            cdap-auth-client
            editdistance
            en_core_web_md
            gensim
            geopy
            imbalanced-learn
            implicit
            ipython
            lda
            lime
            marshmallow-oneofschema
            matplotlib
            numpy
            ortools
            pandas
            pillow
            plotly
            pyldavis
            python-igraph
            pytorch
            pywavelets
            scikit-image
            scikitlearn
            scikit-multilearn
            scipy
            seaborn
            spacy
            thinc
            torchfile
            torchtext
            torchvision
            visdom

            # overridden dependencies
            avro
            cytoolz
            dill
            hexdump
            kafka-python
            liac-arff
            mocket
            msgpack
            msgpack-numpy
            pathlib
            psycopg2
            pyjq
            regex
            smart_open; };

in

pkgs // pkgsOverrides // pkgsPy
