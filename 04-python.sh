#!/usr/bin/env zsh
# if running as a script, edit above to reflect your shell (bash, zsh, etc.)

# # to manually nuke the current installation:
# # 1. uninstall poetry
# curl -sSL https://install.python-poetry.org | python3 - --uninstall
# # 2. remove other directories
# rm -rf ~/miniconda/ ~/miniforge3/ ~/.condarc ~/.conda/ ~/.continuum/ ~/.jupyter/ ~/.ipython/ ~/.local/share/jupyter/ ~/Library/Jupyter/ ~/Library/Caches/pip ~/.poetry/ ~/.local/bin/poetry ~/Library/Caches/pypoetry/ ~/Library/Application\ Support/pypoetry/
# # 3. delete the conda initialize section from ~/.zshrc or ~/.bash_profile

# Platform options are: MacOSX, Linux
# Have not set up for Windows (uses different file extension)
# See these pages for exact package names:
# Miniforge: https://github.com/conda-forge/miniforge/releases/
# Miniconda: https://repo.anaconda.com/miniconda/
PLATFORM='MacOSX'

# Installer options are: miniforge3, miniconda
# Miniforge is managed by the community: https://github.com/conda-forge/miniforge
# Miniconda is managed by Anaconda: https://conda.io/miniconda.html
INSTALLER='miniforge3'

# Exit script immediately if a command exits with a non-zero status
set -e

# Check on configuration options
VALID_PLATFORMS=('MacOSX' 'Linux')
{
    platform_valid=false
    for p in "${VALID_PLATFORMS[@]}"; do
        if [[ "$p" == "$PLATFORM" ]]; then
            platform_valid=true
            break
        fi
    done

    if [[ "$platform_valid" != true ]]; then
        echo "Platform $PLATFORM not supported, use one of ${VALID_PLATFORMS[*]}"
        exit 1
    fi
}

VALID_INSTALLERS=('miniforge3' 'miniconda')
{
    installer_valid=false
    for i in "${VALID_INSTALLERS[@]}"; do
        if [[ "$i" == "$INSTALLER" ]]; then
            installer_valid=true
            break
        fi
    done

    if [[ "$installer_valid" != true ]]; then
        echo "Installer $INSTALLER not supported, use one of ${VALID_INSTALLERS[*]}"
        exit 1
    fi
}

# wget is a prerequisite
{
    if ! command -v wget &>/dev/null; then
        echo 'wget could not be found, please install first'
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
    if [[ "$MY_SHELL" =~ 'zsh' ]]; then
        read -q "REPLY?Assuming your normal shell is $MY_SHELL. Continue (y/n)? "
    elif [[ "$MY_SHELL" =~ 'bash' ]]; then
        read -p "Assuming your normal shell is $MY_SHELL. Continue (y/n)? " -n 1 -r
    fi
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
}

{
    if [[ "$INSTALLER" == 'miniforge3' ]]; then
        # Miniforge: https://github.com/conda-forge/miniforge/
        INSTALL_FILE="Miniforge3-$PLATFORM-$(uname -m).sh"
        INSTALL_URL="https://github.com/conda-forge/miniforge/releases/latest/download/$INSTALL_FILE"
        INSTALL_DIR='miniforge3'
    elif [[ "$INSTALLER" == 'miniconda' ]]; then
        # Miniconda: https://docs.conda.io/projects/conda/en/latest/user-guide/install/macos.html
        INSTALL_FILE="Miniconda3-latest-$PLATFORM-$(uname -m).sh"
        INSTALL_URL="https://repo.continuum.io/miniconda/$INSTALL_FILE"
        INSTALL_DIR='miniconda'
    else
        echo "Unsupported configuration: installer: $INSTALLER"
        exit 1
    fi
}

{
    if [[ "$MY_SHELL" =~ 'zsh' ]]; then
        read -q "REPLY?Installing with installer: $INSTALLER. Continue (y/n)? "
    elif [[ "$MY_SHELL" =~ 'bash' ]]; then
        read -p "Installing with installer: $INSTALLER. Continue (y/n)? " -n 1 -r
    fi
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
}

INSTALL_DIR_PATH="$HOME/$INSTALL_DIR"
INSTALL_FILE_PATH="$HOME/Downloads/$INSTALL_FILE"

# Exit if installer file already exists
{
    if [ -f "$INSTALL_FILE_PATH" ]; then
        echo "$INSTALL_FILE_PATH already exists! Delete before running this script to ensure installation is up-to-date."
        exit 1
    fi
}

{
    if [ ! -f "$INSTALL_FILE_PATH" ]; then
        wget --show-progress -O $INSTALL_FILE_PATH $INSTALL_URL
    fi
}

# Run the install
bash $INSTALL_FILE_PATH -b -p $INSTALL_DIR_PATH

# Initialize (adds to ~/.zshrc or ~/.bash_profile)
# source $INSTALL_DIR_PATH/bin/activate
source $INSTALL_DIR_PATH/etc/profile.d/conda.sh
{
    if [[ "$INSTALLER" == 'miniforge3' ]]; then
        source $INSTALL_DIR_PATH/etc/profile.d/mamba.sh
    fi
}
{
    if [[ "$MY_SHELL" =~ 'zsh' ]]; then
        echo "Initializing conda for zsh"
        conda init zsh
    elif [[ "$MY_SHELL" =~ 'bash' ]]; then
        echo "Initializing conda for bash"
        conda init bash
    fi
    if [[ "$INSTALLER" == 'miniforge3' ]]; then
        mamba shell init
    fi
}

echo "Close this shell and open a new one, then run 05-python-updates.sh"
