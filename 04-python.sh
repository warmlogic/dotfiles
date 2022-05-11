#!/usr/bin/env bash
# if running as a script, edit to reflect the shell you use (bash, zsh, etc.)

# to manually nuke the current installation:
# rm -rf ~/miniconda ~/mambaforge ~/miniforge3 ~/.condarc ~/.conda ~/.continuum ~/.jupyter ~/.ipython ~/.local/share/jupyter/ ~/Library/Jupyter ~/Library/Caches/pip
# # and make sure to edit ~/.zshrc or ~/.bash_profile

# Exit script immediately if a command exits with a non-zero status
set -e

# wget is a prerequisite
if ! command -v wget &> /dev/null
then
    echo "wget could not be found, please install first"
    exit 1
fi

MY_SHELL=$(ps -p $$ -ocomm=)

# Make sure we are running a supported shell
{
if [[ ! "$MY_SHELL" =~ 'zsh' && ! "$MY_SHELL" =~ .*'bash'.* ]]; then
    echo "Shell not supported for this install script: $MY_SHELL"
    exit 1
fi
}

read -p "Assuming your normal shell is $MY_SHELL. Continue (y/n)? " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

# # https://docs.conda.io/projects/conda/en/latest/user-guide/install/macos.html
# INSTALL_DL_FILE="Miniconda3-latest-MacOSX-$(uname -m).sh"
# INSTALL_URL="https://repo.continuum.io/miniconda/$INSTALL_DL_FILE"
# INSTALL_DIR="miniconda"

# # https://github.com/conda-forge/miniforge/
# INSTALL_DL_FILE="Miniforge3-MacOSX-$(uname -m).sh"
# INSTALL_DL_URL="https://github.com/conda-forge/miniforge/releases/latest/download/$INSTALL_DL_FILE"
# INSTALL_DIR="miniforge3"

# # https://github.com/conda-forge/miniforge/
INSTALL_DL_FILE="Mambaforge-MacOSX-$(uname -m).sh"
INSTALL_DL_URL="https://github.com/conda-forge/miniforge/releases/latest/download/$INSTALL_DL_FILE"
INSTALL_DIR="mambaforge"

INSTALL_DIR_PATH="$HOME/$INSTALL_DIR"
INSTALL_DL_PATH="$HOME/Downloads/$INSTALL_DL_FILE"

# Exit if installer file already exists
{
if [ -f "$INSTALL_DL_PATH" ]; then
    echo "$INSTALL_DL_PATH already exists! Delete before running this script to ensure installation is up-to-date."
    exit 0
fi
}

{
if [ ! -f "$INSTALL_DL_PATH" ]; then
    wget --show-progress -O $INSTALL_DL_PATH $INSTALL_URL
fi
}

# install
bash $INSTALL_DL_PATH -b -p $INSTALL_DIR_PATH

# initialize conda (add to ~/.zshrc or ~/.bash_profile)
source $INSTALL_DIR_PATH/bin/activate
{
if [[ "$MY_SHELL" =~ 'zsh' ]]; then
    echo "Initializing conda for zsh"
    conda init zsh
    source $HOME/.zshrc
elif [[ "$MY_SHELL" =~ 'bash' ]]; then
    echo "Initializing conda for bash"
    conda init
    source $HOME/.bashrc
else
    echo "Shell not supported: $MY_SHELL"
    exit 1
fi
}

conda update -q conda -y
conda upgrade --all -y
pip install -U pip

# List info in case things don't work
conda info -a

# # This adds the conda-forge channel below the defaults library
# conda config --append channels conda-forge

# # enable usage of conda command
# . $HOME/$INSTALL_DIR/etc/profile.d/conda.sh

# conda activate base

# update the base environment with lots of good packages
conda env update -f init/environment.yml -q

# configure git to use nbdiff
nbdime config-git --enable --global

# # enable nb_conda_kernels
# python -m nb_conda_kernels.install --enable --prefix="${CONDA_PREFIX}"

# # copy nbextension files into jupyter server's search dir and edit some config files
# jupyter contrib nbextension install --user

# # copy jupyter settings, including enabled extensions
# cp -r .jupyter/ $HOME/.jupyter/

# # add "conda activate" to ~/.bash_profile, enable using it for other envs
# echo '' >> ~/.bash_profile
# echo '# enable conda activate' >> ~/.bash_profile
# echo '. $HOME/'$INSTALL_DIR'/etc/profile.d/conda.sh' >> ~/.bash_profile
# echo '# activate the base environment' >> ~/.bash_profile
# echo 'conda activate' >> ~/.bash_profile

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
