#!/usr/bin/env zsh
# if running as a script, edit above to reflect your shell (bash, zsh, etc.)

# Don't use Conda's method of showing the current virtual environment
# http://conda.pydata.org/docs/config.html#change-command-prompt-changeps1
conda config --set changeps1 False

MY_SHELL=$(ps -p $$ -ocomm=)

# Make sure we are running a supported shell
{
    if [[ ! "$MY_SHELL" =~ 'zsh' && ! "$MY_SHELL" =~ 'bash' ]]; then
        echo "Shell not supported for this install script: $MY_SHELL"
        exit 1
    fi
}

echo "Updating conda"
conda update -n base -q conda -y
conda install ipython -y
conda upgrade --all -y
python -m pip install -U pip

# Upgrade Python
PYTHON_VERSION=3.11
echo "Updating to Python $PYTHON_VERSION"
conda install python=$PYTHON_VERSION ipython -c conda-forge -y

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
        echo '' >>$HOME/.zshrc
        echo '# Python-poetry https://python-poetry.org' >>$HOME/.zshrc
        echo 'export PATH="$HOME/.local/bin:$PATH"' >>$HOME/.zshrc
        source $HOME/.zshrc
    elif [[ "$MY_SHELL" =~ 'bash' ]]; then
        echo '' >>$HOME/.bash_profile
        echo '# Python-poetry https://python-poetry.org' >>$HOME/.bash_profile
        echo 'export PATH="$HOME/.local/bin:$PATH"' >>$HOME/.bash_profile
        source $HOME/.bashrc
    fi
}

# add shell completions for poetry
echo "Adding python-poetry shell completions"
{
    if [[ "$MY_SHELL" =~ 'zsh' ]]; then
        mkdir $HOME/.zfunc
        poetry completions zsh >$HOME/.zfunc/_poetry
    elif [[ "$MY_SHELL" =~ 'bash' ]]; then
        # put in the brew bash completion directory
        if type brew &>/dev/null; then
            poetry completions bash >$(brew --prefix)/etc/bash_completion.d/poetry
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
