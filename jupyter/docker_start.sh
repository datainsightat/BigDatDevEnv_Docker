#!/bin/sh

#Jupyter
jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token=

#Keep Container alive Test
tail -f /dev/null