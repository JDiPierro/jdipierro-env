export HOME=/home/justin
export HOSTED_DIR=/home/justin/Source/jdipierro_env/hosted
export ZSH=${HOME}/.oh-my-zsh
ZSH_THEME="jdipierro"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
plugins=(git)

source $ZSH/oh-my-zsh.sh

export GOPATH="/home/justin/Source/gopath"
export PATH="$PATH:/home/justin/Source/gopath/bin"
export GROOVY_HOME="/usr/local/opt/groovy/libexec"
export VAGRANT_DEFAULT_PROVIDER="virtualbox"

eval "$(thefuck --alias)"
source ${HOSTED_DIR}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
. ${HOSTED_DIR}/z/z.sh

source ${HOME}/.venvburrito/startup.sh
