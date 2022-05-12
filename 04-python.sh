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
