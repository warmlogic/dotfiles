#!/usr/bin/env bash
set -e

# to manually nuke the current miniconda install
# rm -rf ~/miniconda ~/.condarc ~/.conda ~/.continuum ~/.jupyter ~/.ipython ~/.local/share/jupyter/ ~/Library/Jupyter

MC_DIR="miniconda"
MC_DL_FILE="Miniconda3.sh"
MC_DL_PATH="$HOME/Downloads/$MC_DL_FILE"
MC_DIR_PATH="$HOME/$MC_DIR"

# Exit if installer file already exists
{
if [ -f "$MC_DL_PATH" ]; then
    echo "$MC_DL_PATH already exists! Delete before running this script to ensure installation is up-to-date."
    exit 0
fi
}

# Download installer file only if it does not already exist
# Use Miniforge on an Apple Silicon Mac
{
if [[ $(uname -m) == 'arm64' ]]; then
    MC_URL=https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-$(uname -m).sh
else
    MC_URL=https://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh
fi
}

{
if [ ! -f "$MC_DL_PATH" ]; then
    wget --show-progress -O $MC_DL_PATH $MC_URL
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

# conda install -n base _license -y

conda upgrade --all -y

# List info in case things don't work
conda info -a

# This adds the conda-forge channel below the defaults library
conda config --append channels conda-forge

# enable usage of conda command
. $HOME/$MC_DIR/etc/profile.d/conda.sh

conda activate base

# upgrade pip
pip install -U pip

# update the base environment with lots of good packages
conda env update -f init/environment.yml -q

# # enable nb_conda_kernels
# python -m nb_conda_kernels.install --enable --prefix="${CONDA_PREFIX}"

# # copy nbextension files into jupyter server's search dir and edit some config files
# jupyter contrib nbextension install --user

# # copy jupyter settings, including enabled extensions
# cp -r .jupyter/ $HOME/.jupyter/

# configure git to use nbdiff
nbdime config-git --enable --global

# add "conda activate" to ~/.bash_profile, enable using it for other envs
echo '' >> ~/.bash_profile
echo '# enable conda activate' >> ~/.bash_profile
echo '. $HOME/'$MC_DIR'/etc/profile.d/conda.sh' >> ~/.bash_profile
echo '# activate the base environment' >> ~/.bash_profile
echo 'conda activate' >> ~/.bash_profile

# # Additional ML packages
# # because it's difficult to install xgboost on macOS via the environment file
# conda install xgboost -y
# # auto-sklearn http://automl.github.io/auto-sklearn/stable/installation.html
# curl https://raw.githubusercontent.com/automl/auto-sklearn/master/requirements.txt | xargs -n 1 -L 1 pip install
# pip install -U auto-sklearn

# download and link spacy language model
# python -m spacy download en
python -m spacy download en_core_web_sm
# python -m spacy download en_core_web_lg

# # PyTorch
# conda install pytorch torchvision -c pytorch  # http://pytorch.org/
