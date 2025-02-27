#!/usr/bin/env zsh
# if running as a script, edit above to reflect your shell (bash, zsh, etc.)

# # to manually nuke the current installation:
# # 1. uninstall poetry
# curl -sSL https://install.python-poetry.org | python3 - --uninstall
# # 2. remove other directories
# rm -rf ~/miniconda/ ~/mambaforge/ ~/miniforge3/ ~/.condarc ~/.conda/ ~/.continuum/ ~/.jupyter/ ~/.ipython/ ~/.local/share/jupyter/ ~/Library/Jupyter/ ~/Library/Caches/pip ~/.poetry/ ~/.local/bin/poetry ~/Library/Caches/pypoetry/ ~/Library/Application\ Support/pypoetry/
# # 3. delete the conda initialize section from ~/.zshrc or ~/.bash_profile

# Platform options are: MacOSX, Linux
# Have not set up for Windows (uses different file extension)
# See these pages for exact package names:
# Miniforge: https://github.com/conda-forge/miniforge/releases/
# Miniconda: https://repo.anaconda.com/miniconda/
PLATFORM='MacOSX'

# Package manager options are: conda
# Conda: https://conda.io
MANAGER='conda'

# Installer options are: miniforge, miniconda
# Miniforge is managed by the community: https://github.com/conda-forge/miniforge
# Miniconda is managed by Anaconda: https://conda.io/miniconda.html
INSTALLER='miniforge'

# Exit script immediately if a command exits with a non-zero status
set -e

# Check on configuration options
VALID_PLATFORMS=('MacOSX' 'Linux')
{
if [[ ! "${VALID_PLATFORMS[(r)$PLATFORM]}" == "$PLATFORM" ]]; then
    echo "Platform $PLATFORM not supported, use one of ${VALID_PLATFORMS[*]}"
    exit 1
fi
}

VALID_MANAGERS=('conda')
{
if [[ ! "${VALID_MANAGERS[(r)$MANAGER]}" == "$MANAGER" ]]; then
    echo "Package manager $MANAGER not supported, use one of ${VALID_MANAGERS[*]}"
    exit 1
fi
}

VALID_INSTALLERS=('miniforge' 'miniconda')
{
if [[ ! "${VALID_INSTALLERS[(r)$INSTALLER]}" == "$INSTALLER" ]]; then
    echo "Installer $INSTALLER not supported, use one of ${VALID_INSTALLERS[*]}"
    exit 1
fi
}

# wget is a prerequisite
{
if ! command -v wget &> /dev/null; then
    echo 'wget could not be found, please install first'
    exit 1
fi;
}

MY_SHELL=$(ps -p $$ -ocomm=)

# Make sure we are running a supported shell
{
if [[ ! "$MY_SHELL" =~ 'zsh' && ! "$MY_SHELL" =~ 'bash' ]]; then
    echo "Shell not supported for this install script: $MY_SHELL"
    exit 1
fi;
}

{
if [[ "$MY_SHELL" =~ 'zsh' ]]; then
    read -q "REPLY?Assuming your normal shell is $MY_SHELL. Continue (y/n)? "
elif [[ "$MY_SHELL" =~ 'bash' ]]; then
    read -p "Assuming your normal shell is $MY_SHELL. Continue (y/n)? " -n 1 -r
fi;
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi;
}

{
if [[ "$MANAGER" == 'conda' && "$INSTALLER" == 'miniforge' ]]; then
    # Miniforge and conda: https://github.com/conda-forge/miniforge/
    INSTALL_FILE="Miniforge3-$PLATFORM-$(uname -m).sh"
    INSTALL_URL="https://github.com/conda-forge/miniforge/releases/latest/download/$INSTALL_FILE"
    INSTALL_DIR='miniforge3'
elif [[ "$MANAGER" == 'conda' && "$INSTALLER" == 'miniconda' ]]; then
    # Miniconda: https://docs.conda.io/projects/conda/en/latest/user-guide/install/macos.html
    INSTALL_FILE="Miniconda3-latest-$PLATFORM-$(uname -m).sh"
    INSTALL_URL="https://repo.continuum.io/miniconda/$INSTALL_FILE"
    INSTALL_DIR='miniconda'
else
    echo "Unsupported configuration: package manager: $MANAGER, installer: $INSTALLER"
    exit 1
fi
}

{
read -q "REPLY?Installing with package manager: $MANAGER, installer: $INSTALLER. Continue (y/n)? "
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi;
}

INSTALL_DIR_PATH="$HOME/$INSTALL_DIR"
INSTALL_FILE_PATH="$HOME/Downloads/$INSTALL_FILE"

# Exit if installer file already exists
{
if [ -f "$INSTALL_FILE_PATH" ]; then
    echo "$INSTALL_FILE_PATH already exists! Delete before running this script to ensure installation is up-to-date."
    exit 1
fi;
}

{
if [ ! -f "$INSTALL_FILE_PATH" ]; then
    wget --show-progress -O $INSTALL_FILE_PATH $INSTALL_URL
fi;
}

# Install conda
bash $INSTALL_FILE_PATH -b -p $INSTALL_DIR_PATH

# Initialize conda (add to ~/.zshrc or ~/.bash_profile)
source $INSTALL_DIR_PATH/bin/activate
{
if [[ "$MY_SHELL" =~ 'zsh' ]]; then
    echo "Initializing conda for zsh"
    conda init zsh
elif [[ "$MY_SHELL" =~ 'bash' ]]; then
    echo "Initializing conda for bash"
    conda init
fi;
}

echo "Close this shell and open a new one, then run 05-python-updates.sh"
