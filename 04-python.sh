#!/usr/bin/env bash
# if running as a script, edit to reflect the shell you use (bash, zsh, etc.)

# # to manually nuke the current installation:
# # 1. uninstall poetry
# curl -sSL https://install.python-poetry.org | python3 - --uninstall
# # 2. remove other directories
# rm -rf ~/miniconda/ ~/mambaforge/ ~/miniforge3/ ~/.condarc ~/.conda/ ~/.continuum/ ~/.jupyter/ ~/.ipython/ ~/.local/share/jupyter/ ~/Library/Jupyter/ ~/Library/Caches/pip ~/.poetry/ ~/.local/bin/poetry ~/Library/Caches/pypoetry/ ~/Library/Application\ Support/pypoetry/
# # 3. delete the conda initialize section from ~/.zshrc or ~/.bash_profile

# Exit script immediately if a command exits with a non-zero status
set -e

# wget is a prerequisite
{
if ! command -v wget &> /dev/null
then
    echo "wget could not be found, please install first"
    exit 1
fi
}

MY_SHELL=$(ps -p $$ -ocomm=)

# Make sure we are running a supported shell
{
if [[ ! "$MY_SHELL" =~ 'zsh' && ! "$MY_SHELL" =~ 'bash' ]]; then
    echo "Shell not supported for this install script: $MY_SHELL"
    exit 1
fi
}

{
read -p "Assuming your normal shell is $MY_SHELL. Continue (y/n)? " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi
}

# # Miniconda: https://docs.conda.io/projects/conda/en/latest/user-guide/install/macos.html
# INSTALL_FILE="Miniconda3-latest-MacOSX-$(uname -m).sh"
# INSTALL_URL="https://repo.continuum.io/miniconda/$INSTALL_FILE"
# INSTALL_DIR="miniconda"

# # Miniforge and conda: https://github.com/conda-forge/miniforge/
# INSTALL_FILE="Miniforge3-MacOSX-$(uname -m).sh"
# INSTALL_URL="https://github.com/conda-forge/miniforge/releases/latest/download/$INSTALL_FILE"
# INSTALL_DIR="miniforge3"

# Miniforge and mamba https://github.com/mamba-org/mamba
INSTALL_FILE="Mambaforge-MacOSX-$(uname -m).sh"
INSTALL_URL="https://github.com/conda-forge/miniforge/releases/latest/download/$INSTALL_FILE"
INSTALL_DIR="mambaforge"

INSTALL_DIR_PATH="$HOME/$INSTALL_DIR"
INSTALL_FILE_PATH="$HOME/Downloads/$INSTALL_FILE"

# # Exit if installer file already exists
# {
# if [ -f "$INSTALL_FILE_PATH" ]; then
#     echo "$INSTALL_FILE_PATH already exists! Delete before running this script to ensure installation is up-to-date."
#     exit 0
# fi
# }

{
if [ ! -f "$INSTALL_FILE_PATH" ]; then
    wget --show-progress -O $INSTALL_FILE_PATH $INSTALL_URL
fi
}

# install
bash $INSTALL_FILE_PATH -b -p $INSTALL_DIR_PATH

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

echo "Updating conda"
conda update -q conda -y
conda upgrade --all -y
python -m pip install -U pip

# List info
conda info -a

# # This adds the conda-forge channel below the defaults library
# conda config --append channels conda-forge

# # enable usage of conda command
# . $HOME/$INSTALL_DIR/etc/profile.d/conda.sh

# conda activate base

# update the base environment with lots of good packages
echo "Updating conda base environment"
conda env update -f init/environment.yml -q

# download and link spacy language model
echo "Downloading spacy language model"
# python -m spacy download en
python -m spacy download en_core_web_sm
# python -m spacy download en_core_web_lg

# configure git to use nbdiff
echo "Configuring git to use nbdiff"
nbdime config-git --enable --global

# install python-poetry https://python-poetry.org
echo "Installing python-poetry"
curl -sSL https://install.python-poetry.org | python3 -

# add poetry path to ~/.zshrc or ~/.bash_profile
echo "Adding python-poetry path to ~/.zshrc or ~/.bash_profile"
{
if [[ "$MY_SHELL" =~ 'zsh' ]]; then
    echo '' >> $HOME/.zshrc
    echo '# Python-poetry https://python-poetry.org' >> $HOME/.zshrc
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> $HOME/.zshrc
    source $HOME/.zshrc
elif [[ "$MY_SHELL" =~ 'bash' ]]; then
    echo '' >> $HOME/.bash_profile
    echo '# Python-poetry https://python-poetry.org' >> $HOME/.bash_profile
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> $HOME/.bash_profile
    source $HOME/.bashrc
fi
}

# add shell completions for poetry
echo "Adding python-poetry shell completions"
{
if [[ "$MY_SHELL" =~ 'zsh' ]]; then
    mkdir $HOME/.zfunc
    poetry completions zsh > $HOME/.zfunc/_poetry
elif [[ "$MY_SHELL" =~ 'bash' ]]; then
    # put in the brew bash completion directory
    if type brew &>/dev/null
    then
    poetry completions bash > $(brew --prefix)/etc/bash_completion.d/poetry
    fi
fi
}

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

# # PyTorch
# conda install pytorch torchvision -c pytorch  # http://pytorch.org/
