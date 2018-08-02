#!/usr/bin/env bash

MC_DIR="miniconda3"
MC_DL_FILE="Miniconda3-latest-MacOSX-x86_64.sh"
MC_DL_PATH="$HOME/Downloads/$MC_DL_FILE"
MC_DIR_PATH="$HOME/$MC_DIR"

# # Exit if miniconda file already exists
# {
# if [ -f "$MC_DL_PATH" ]; then
#     echo "$MC_DL_PATH already exists! Delete before running this script to ensure installation is up-to-date."
#     exit 0
# fi
# }

# Download miniconda file only if it does not already exist
{
if [ ! -f "$MC_DL_PATH" ]; then
    wget --show-progress -O $MC_DL_PATH https://repo.continuum.io/miniconda/$MC_DL_FILE
fi
}

# install
bash $MC_DL_PATH -b -p $MC_DIR_PATH

# Add to and source .bashrc
export PATH="$MC_DIR_PATH/bin:$PATH"
# Clears history
hash -r

# # Don't ask if you want to update
# conda config --set always_yes yes

# -q for quiet
conda update -q conda -y

conda install -n root _license -y

conda upgrade -y --all

# List info in case things don't work
conda info -a

# This adds the conda-forge channel below the defaults library
conda config --append channels conda-forge

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

# Create separate environment called py3
conda create -q --name py3 python=3 $packages -y
source activate py3

# For Python file linting
pip install -U mypy

# Amazon AWS command line interface
pip install -U awscli

# For provisioning AWS spot instances
pip install -U spotr # https://github.com/samuelreh/spotr

# Dataset loading and profiling
pip install -U xlrd
pip install -U missingno # https://github.com/ResidentMario/missingno
pip install -U pandas-profiling # https://github.com/pandas-profiling/pandas-profiling

# External datasets
pip install -U pandas-datareader # https://github.com/pydata/pandas-datareader
pip install -U kaggle

# Utility packages
pip install -U tqdm
pip install -U nbdime # nbdiff
nbdime config-git --enable --global # nbdiff
# pip install -U pytest
# pip install -U nose
pip install -U graphviz

# ML packages
pip install -U rfpimp # https://github.com/parrt/random-forest-importances
pip install -U imbalanced-learn
pip install -U lime # https://github.com/marcotcr/lime
pip install -U lightgbm # https://github.com/Microsoft/LightGBM
pip install -U xgboost
# auto-sklearn http://automl.github.io/auto-sklearn/stable/installation.html
curl https://raw.githubusercontent.com/automl/auto-sklearn/master/requirements.txt | xargs -n 1 -L 1 pip install
pip install -U auto-sklearn
# TPOT http://epistasislab.github.io/tpot/installing/
pip install -U deap update_checker stopit
pip install -U tpot

# Foundational NLP packages
pip install -U spacy # https://spacy.io/
python -m spacy download en
# python -m spacy download en_core_web_lg
pip install -U gensim # https://radimrehurek.com/gensim/
pip install -U nltk

# NLP building on top of spaCy or others
pip install -U textacy # https://github.com/chartbeat-labs/textacy
# pip install -U textblob # https://github.com/sloria/TextBlob
# python -m textblob.download_corpora # downloads NLTK data
# pip install -U thinc # https://github.com/explosion/thinc
# pip install -U pattern # https://github.com/clips/pattern

# NLP utilities
pip install -U ftfy # https://github.com/LuminosoInsight/python-ftfy
pip install -U fuzzywuzzy # https://github.com/seatgeek/fuzzywuzzy
pip install -U python-Levenshtein # for fuzzywuzzy
pip install -U pyldavis # https://github.com/bmabey/pyLDAvis

# Spell checking
# pip install -U pyenchant # https://github.com/rfk/pyenchant
# pip install -U language_check # https://github.com/myint/language-check

# # Neural network packages
# pip install -U tensorflow
# pip install -U keras
# # http://pytorch.org/

# # Plotly and Dash
# pip install -U plotly # https://plot.ly/python/
# pip install -U dash # The core dash backend
# pip install -U dash-renderer # The dash front-end
# pip install -U dash-html-components # HTML components
# pip install -U dash-core-components # Supercharged components

# Add Jupyter kernel for this environment and set the display name
# http://ipython.readthedocs.io/en/stable/install/kernel_install.html#kernels-for-different-environments
python -m ipykernel install --user --name py3 --display-name "py3"

# # "source activate"
# echo '' >> ~/.bash_profile
# echo '# enable source activate' >> ~/.bash_profile
# echo '# https://conda.io/docs/user-guide/install/macos.html' >> ~/.bash_profile
# echo 'export PATH="$HOME/'$MC_DIR'/bin:$PATH"' >> ~/.bash_profile
# echo '# activate the py3 environment' >> ~/.bash_profile
# echo 'source activate py3' >> ~/.bash_profile

# "conda activate"
echo '' >> ~/.bash_profile
echo '# enable conda activate' >> ~/.bash_profile
echo '. $HOME/'$MC_DIR'/etc/profile.d/conda.sh' >> ~/.bash_profile
echo '# activate the py3 environment' >> ~/.bash_profile
echo 'conda activate py3' >> ~/.bash_profile
