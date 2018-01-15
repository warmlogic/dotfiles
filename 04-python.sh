#!/usr/bin/env bash

mc_filename="Miniconda3-latest-MacOSX-x86_64.sh"
mc_dl_path="$HOME/Downloads/$mc_filename"
mc_dir="$HOME/miniconda3"

# # Exit if miniconda file already exists
# {
# if [ -f "$mc_dl_path" ]; then
#     echo "$mc_dl_path already exists! Delete before running this script to ensure installation is up-to-date."
#     exit 0
# fi
# }

# Download miniconda file only if it does not already exist
{
if [ ! -f "$mc_dl_path" ]; then
    wget --show-progress -O $mc_dl_path https://repo.continuum.io/miniconda/$mc_filename
fi
}

# install
bash $mc_dl_path -b -p $mc_dir

# Add to and source .bashrc
export PATH="$mc_dir/bin:$PATH"
# Clears history
hash -r

# # Don't ask if you want to update
# conda config --set always_yes yes

# -q for quiet
conda update -q conda

conda install -n root _license

# List info in case things don't work
conda info -a

# This adds the conda-forge channel below the defaults library
conda config --append channels conda-forge

# with mkl
packages='pip
mkl
numpy
scipy
scikit-learn
pandas
statsmodels
matplotlib
seaborn
cython
jupyter
notebook
ipywidgets
jupyter_contrib_nbextensions
s3fs
networkx'

# # no mkl
# packages='pip
# nomkl
# numpy
# scipy
# scikit-learn
# pandas
# statsmodels
# matplotlib
# seaborn
# cython
# jupyter
# notebook
# ipywidgets
# jupyter_contrib_nbextensions
# s3fs
# networkx
# pandas-datareader'

# # removed:
# mpld3
# pyparsing
# nomkl
# openblas # need this with nomkl?
# blas

# # Only including r in py3 because conda install r and py2 don't work.
# # If you need it, force
# conda create -q --name py3 --channel r r r-irkernel r-recommended r-essentials rpy2 python=3 $packages -y

conda create -q --name py3 python=3 $packages -y
source activate py3

# additional packages
pip install -U lightgbm # https://github.com/Microsoft/LightGBM
pip install -U xgboost
pip install -U imbalanced-learn
pip install -U xlrd
pip install -U tqdm
pip install -U pandas-profiling # https://github.com/pandas-profiling/pandas-profiling
pip install -U pandas-datareader # https://github.com/pydata/pandas-datareader
pip install -U graphviz
pip install -U missingno # https://github.com/ResidentMario/missingno
pip install -U pytest
# pip install -U kaggle-cli

# NLP packages
pip install -U ftfy # https://github.com/LuminosoInsight/python-ftfy
pip install -U nltk
pip install -U spacy # https://spacy.io/
python -m spacy download en
# pip install -U thinc # https://github.com/explosion/thinc
pip install -U gensim # https://radimrehurek.com/gensim/
pip install -U pyldavis # https://github.com/bmabey/pyLDAvis
# pip install -U fuzzywuzzy # https://github.com/seatgeek/fuzzywuzzy
# pip install -U python-Levenshtein # for fuzzywuzzy
# pip install -U textacy # https://github.com/chartbeat-labs/textacy
# pip install -U pattern # https://github.com/clips/pattern

# neural network packages
# pip install -U tensorflow
# pip install -U keras
# http://pytorch.org/

# # plotly and dash
# pip install -U plotly # https://plot.ly/python/
# pip install -U dash # The core dash backend
# pip install -U dash-renderer # The dash front-end
# pip install -U dash-html-components # HTML components
# pip install -U dash-core-components # Supercharged components

# Set the display name for this kernel
python -m ipykernel install --user --name py3 --display-name "py3"
source deactivate

# conda create -q --name py2 python=2 $packages -y
# source activate py2

# # Set the display name for this kernel
# python -m ipykernel install --user --name py2 --display-name "py2"
# source deactivate
