export HOME=$(cd ~ && pwd)
export HOSTED_DIR=${HOME}/Source/jdipierro_env/hosted
export ZSH=${HOME}/.oh-my-zsh
ZSH_THEME="jdipierro"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
plugins=(git autoenv docker python osx)

# Add my custom bin directory
export PATH="$PATH:/Users/jdipierro/bin"

source $ZSH/oh-my-zsh.sh

export VAGRANT_DEFAULT_PROVIDER="virtualbox"

source ${HOSTED_DIR}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
. ${HOSTED_DIR}/z/z.sh

source ${HOME}/.venvburrito/startup.sh
source <(kubectl completion zsh)

if [[ -f ${HOME}/.aliases ]]; then
  source ${HOME}/.aliases
fi
