export ZSH=/Users/jdipierro/.oh-my-zsh
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
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
. `brew --prefix`/etc/profile.d/z.sh
