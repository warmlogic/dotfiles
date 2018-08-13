#!/usr/bin/env bash

# to manually nuke the current miniconda install
# rm -rf ~/miniconda3 ~/.condarc ~/.conda ~/.continuum ~/.jupyter ~/.ipython ~/.local/share/jupyter/ ~/Library/Jupyter

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

conda install -n base _license -y

conda upgrade --all -y

# List info in case things don't work
conda info -a

# This adds the conda-forge channel below the defaults library
conda config --append channels conda-forge

# copy jupyter settings
if [ ! -d "$HOME/.jupyter" ]; then
  cp -r .jupyter $HOME/.jupyter
fi

# packages for base environment
packages='awscli
cython
feather-format
ipykernel
ipython
ipywidgets
jupyter
jupyter_contrib_nbextensions
matplotlib
mkl
mypy
nb_conda_kernels
nbconvert
nbdime
nbformat
nose
notebook
numpy
pandas
pip
pytest
s3fs
scipy
seaborn
smart_open
tqdm
widgetsnbextension
xlrd'

# Install packages to run Jupyter Notebook server with automatic kernels per environment via nb_conda_kernels
conda install -n base $packages -y

# enable usage of conda command
. $HOME/$MC_DIR/etc/profile.d/conda.sh

conda activate base

# enable nb_conda_kernels
python -m nb_conda_kernels.install --enable --prefix="${CONDA_PREFIX}"

# configure git to use nbdiff
nbdime config-git --enable --global # nbdiff

# upgrade/install a couple packages in base via pip
pip install -U pip
pip install -U kaggle

# conda deactivate

# create the py3 environment with lots of good packages
conda env create -f init/environment-py3.yml -q --force

# add "source activate" to ~/.bash_profile, enable using it for other envs
# echo '' >> ~/.bash_profile
# echo '# enable source activate' >> ~/.bash_profile
# echo '# https://conda.io/docs/user-guide/install/macos.html' >> ~/.bash_profile
# echo 'export PATH="$HOME/'$MC_DIR'/bin:$PATH"' >> ~/.bash_profile
# echo '# activate the base environment' >> ~/.bash_profile
# echo 'source activate base' >> ~/.bash_profile

# add "conda activate" to ~/.bash_profile, enable using it for other envs
echo '' >> ~/.bash_profile
echo '# enable conda activate' >> ~/.bash_profile
echo '. $HOME/'$MC_DIR'/etc/profile.d/conda.sh' >> ~/.bash_profile
echo '# activate the base environment' >> ~/.bash_profile
echo 'conda activate' >> ~/.bash_profile

# activate the py3 environment
conda activate py3

# need to update pip in py3
pip install -U pip

# because it's difficult to install xgboost on macOS via environment-py3.yml
conda install xgboost -y

# # For Python file linting
# pip install -U mypy

# # Amazon AWS command line interface
# pip install -U awscli

# # For provisioning AWS spot instances
# pip install -U spotr # https://github.com/samuelreh/spotr

# # Dataset loading and profiling
# pip install -U xlrd
# pip install -U missingno # https://github.com/ResidentMario/missingno
# pip install -U pandas-profiling # https://github.com/pandas-profiling/pandas-profiling

# # External datasets
# pip install -U pandas-datareader # https://github.com/pydata/pandas-datareader
# pip install -U kaggle

# Utility packages
# pip install -U tqdm
# pip install -U nbdime # nbdiff
# nbdime config-git --enable --global # nbdiff
# pip install -U pytest
# pip install -U nose
# pip install -U graphviz

# ML packages
# pip install -U rfpimp # https://github.com/parrt/random-forest-importances
# pip install -U imbalanced-learn
# pip install -U lime # https://github.com/marcotcr/lime
# pip install -U lightgbm # https://github.com/Microsoft/LightGBM
# pip install -U xgboost
# auto-sklearn http://automl.github.io/auto-sklearn/stable/installation.html
curl https://raw.githubusercontent.com/automl/auto-sklearn/master/requirements.txt | xargs -n 1 -L 1 pip install
pip install -U auto-sklearn
# TPOT http://epistasislab.github.io/tpot/installing/
# pip install -U deap update_checker stopit
# pip install -U tpot

# Foundational NLP packages
# pip install -U spacy # https://spacy.io/
python -m spacy download en
# python -m spacy download en_core_web_lg
# pip install -U gensim # https://radimrehurek.com/gensim/
# pip install -U nltk

# NLP building on top of spaCy or others
# pip install -U textacy # https://github.com/chartbeat-labs/textacy
# pip install -U textblob # https://github.com/sloria/TextBlob
# python -m textblob.download_corpora # downloads NLTK data
# pip install -U thinc # https://github.com/explosion/thinc
# pip install -U pattern # https://github.com/clips/pattern

# # NLP utilities
# pip install -U ftfy # https://github.com/LuminosoInsight/python-ftfy
# pip install -U fuzzywuzzy # https://github.com/seatgeek/fuzzywuzzy
# pip install -U python-Levenshtein # for fuzzywuzzy
# pip install -U pyldavis # https://github.com/bmabey/pyLDAvis

# # Spell checking
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

# # Add Jupyter kernel for this environment and set the display name
# # http://ipython.readthedocs.io/en/stable/install/kernel_install.html#kernels-for-different-environments
# python -m ipykernel install --user --name py3 --display-name "py3"

# deactivate py3 environment
conda deactivate
