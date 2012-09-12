#!/bin/bash
# This script starts octave and adds all subfolders to the path.
# Authors: Alexandru Sorici, Tudor Berariu / August 2012
octave --persist --eval "addpath(genpath('.'))"
