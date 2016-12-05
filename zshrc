export HOME=/home/justin
export HOSTED_DIR=/home/justin/Source/jdipierro_env/hosted
export ZSH=${HOME}/.oh-my-zsh
ZSH_THEME="jdipierro"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

export GOPATH="/Users/jdipierro/Source/gopath"
export PATH="$PATH:/Users/jdipierro/Source/gopath/bin"
export GROOVY_HOME="/usr/local/opt/groovy/libexec"

eval "$(thefuck --alias)"
source ${HOSTED_DIR}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
. ${HOSTED_DIR}/z/z.sh
