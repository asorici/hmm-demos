#!/bin/bash
# This script starts matlab and adds all subfolders to the path.
# Authors: Alexandru Sorici, Tudor Berariu / August 2012
matlab -nosplash -r "addpath(genpath('.'))"
