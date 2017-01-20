export HOME=$(cd ~ && pwd)
export HOSTED_DIR=${HOME}/Source/jdipierro_env/hosted
export ZSH=${HOME}/.oh-my-zsh
ZSH_THEME="jdipierro"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
plugins=(git)

source $ZSH/oh-my-zsh.sh

export GOPATH="${HOME}/Source/gopath"
export PATH="$PATH:${HOME}/Source/gopath/bin"
export GROOVY_HOME="/usr/local/opt/groovy/libexec"
export VAGRANT_DEFAULT_PROVIDER="virtualbox"
export HOMEBREW_GITHUB_API_TOKEN="681af376ca1b63ec3e606a32bc60baf484fb1716"

eval "$(thefuck --alias)"
source ${HOSTED_DIR}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
. ${HOSTED_DIR}/z/z.sh

source ${HOME}/.venvburrito/startup.sh
