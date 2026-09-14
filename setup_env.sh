#!/usr/bin/env bash

cat <<EOM
FerretWithASpork's Environment Initializer
                                            ,,_
                                g@L  ,     ,J@[Q@.,,gD*%k        ,,
                               J@QFS@*%kw#SE@p ;; @P    ?@,    ,@E2k
         ,A A A A.              ^@2@E  SE^@Q@    {P.,w,  SBB@BP*.@U@.
        ;@ V V V B@L              JULg@kBFSE      @@*^%Zk?*    ,#E@F
     ,gg@.        SL              JF   Sk       .F 3.,gF:L    4@@*;
    @F;?1        JP           ;ggg@z   F{       @L.    cz@      *4@.,
    SL  @.     ,@F            @P; JSL  QE       ?L3w.@@.@F         3@.
   ,g@b.J@. ,@@*             @B    %@@@B#.       3@pCJ@P;           ?@
 ;D^ ; ^SD.@P^^@.            SF     ;F           Q.;               .g@.
:@.  3k@E2P; /!J@.      ..,, J@)   ;F           ;F ,,gm@F          J@P
 @L   SE@F :.;BJ@.         ;^={@g#UE          ,gCg#F@ .@.         ,}E
 J@k.gB@@Qgg@P.2E         ,.c=@E SE325BBESpP*^;,,@P5Qp*         .@EP
 J@.   JBJE  :@S.       f^  ,P4@. ^Q2vuDgP;,;xZ2gBP*; ^-        4@.
  ^S@@BP.@.  ;F@L         <*   ;*Bp@De,      ;@E;;^c.._          @L
   SL  ;D^SL   J@.                 ^@.;*%@NP*;;;@gg.             QX.
   ^0BMP  ^@.   ^@L                 ^@@gp,,gBP^;    ^.            S@L
           J@     ^Q.                  ,@P;                      ;J@
            @.      ?@.              ,@P;                        JFI.
            @L       ^B@@BBB@@@pgw,gB*                            @#
            SL                 ,g#P;                           .gJ@
            ^@.              ,@P;                    ,gpps     @S@;
             ?@.          ,@P;                      ;Lggpgs   @PP
              ^@L   _,,gD*;                         %^   ^%p.@P
               @S, *C2P;                                    ^4@.
               @@@@EB^ ,p=                                     ^%@.,
                 %@@L@E;                                          ;^48@gw,,_
                   @@@L                                                  ;%E@L
                   ;J@L,@F                                        ,.        E@.
                     Vk@L   ,                            ,,     ,@*         SE@
                      %@@. :F                     4R8R@P**WBgw,JF           ?@V
                        ^@u@L                         ?k      ;@L          g@E
                          %QL                          SL     :@L         :SJL
                            QL                         ^@L     @L        .@F;
                            ^QL                         ^QL    Jk       .@F
                              %L                          SL ,,J@.     .@F
                               3@.                         %@F;3S     ,@F
EOM

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOG_DIR="${DIR}/log"

mkdir -p "${LOG_DIR}"
: > "${LOG_DIR}/run.log"

function detect_os() {
  case "$(uname -s)" in
    Darwin)
      OS_FAMILY="macos"
      ;;
    Linux)
      if [[ ! -r /etc/os-release ]]; then
        echo "ERROR: Cannot identify this Linux distribution (missing /etc/os-release)."
        exit 1
      fi

      source /etc/os-release
      case "${ID:-} ${ID_LIKE:-}" in
        *debian*|*ubuntu*) OS_FAMILY="debian" ;;
        *fedora*|*rhel*|*centos*) OS_FAMILY="fedora" ;;
        *)
          echo "ERROR: Unsupported Linux distribution: ${PRETTY_NAME:-${ID:-unknown}}"
          echo "You'll have to teach the ferret about this one."
          exit 1
          ;;
      esac
      ;;
    *)
      echo "ERROR: Unsupported OS: $(uname -s)"
      echo "You'll have to teach the ferret about this one."
      exit 1
      ;;
  esac
}

detect_os

function msg() {
  echo "$1" | tee -a "${LOG_DIR}/run.log"
}

DEBUG=
function debug() { if [ "${DEBUG}" == "1" ]; then msg $1; fi }
debug "Debugging Enabled"

function install() {
  PKG=$1
  if [ "$2" == "1" ] && [ $? ]; then
    debug "${PKG} detected by custom test"
    return
  elif [ "$2" == "2" ]; then
    debug "Skipping check"
  elif which ${PKG} > /dev/null 2>&1; then
    debug "${PKG} detected by which"
    return
  fi
  msg "Installing ${PKG}..."
  case "${OS_FAMILY}" in
    macos)
      brew list ${PKG} >/dev/null 2>&1 || brew install ${PKG} > "${LOG_DIR}/install_${PKG}" 2>&1
      return $?;;
    fedora)
      sudo yum install -y ${PKG} > "${LOG_DIR}/install_${PKG}" 2>&1
      return $?;;
    debian)
      sudo apt-get install -y -o DPkg::Options::=--force-confold "${PKG}" > "${LOG_DIR}/install_${PKG}" 2>&1
      return $?;;
    *)
      msg "ERROR: Don't know how to install on this system."
      exit 1;;
  esac
  if [ "$?" ]; then
    debug "Error installing ${PKG}. Please attempt to fix manually."
    exit 1
  fi
  msg "Done, moving on..."
}

function install_hosted() {
  HOSTED_PKG=$1
  GIT_URL=$2
  mkdir -p ${DIR}/hosted
  if [ ! -d "${DIR}/hosted/${HOSTED_PKG}" ]; then
    msg "Installing ${HOSTED_PKG}..."
    git clone ${GIT_URL} ${DIR}/hosted/${HOSTED_PKG} --depth=1 > "${LOG_DIR}/install_${HOSTED_PKG}" 2>&1
  fi
}

############
### MAIN ###
############

# Make sure Homebrew is installed if we're on a mac.
if [[ "${OS_FAMILY}" == "macos" ]]; then
  if ! brew --version > /dev/null 2>&1; then
    msg "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" > "${LOG_DIR}/install_homebrew" 2>&1
  fi
fi

# Set up awesome things
install zsh
if ! [ -d ~/.oh-my-zsh/ ]; then
  msg "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" > "${LOG_DIR}/install_ohmyzsh" 2>&1
  msg "Installing custom ZSH theme..."
  ln -s  ${DIR}/files/jdipierro.zsh-theme ~/.oh-my-zsh/themes/
fi
install zsh-syntax-highlighting
install thefuck
install z
install lolcat

# Install kubernetes PS1 info script:
#install_hosted kube-ps1 git@github.com:jonmosco/kube-ps1.git

if [ ! -f ~/.config/flake8 ]; then
  msg "Fuck up Pep8"
  cat > ~/.config/flake8 <<-EOM
[flake8]
ignore: C901, D100, D101, D102, D103, D104, D105, D200, D204, D205, D301, D400, D401, D402, D403, E111, E114, E121, E128, E221, E402, E501, E731, F403, I100, I101, I201, N802
EOM
fi

if ! cat ~/.zshrc | grep ${DIR} >/dev/null ; then
  msg "Redirecting zshrc to our git-managed file..."
  cat > ~/.zshrc <<-EOM
source ${DIR}/zshrc
source ${DIR}/aliases
EOM
fi

if [[ ! -f ~/.vimrc ]]; then
  msg "Setting up VIM just the way you like it..."
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  ln -s ${DIR}/vimrc ~/.vimrc
  mkdir -p ~/.vim/colors
  cp ${DIR}/files/vividchalk.vim ~/.vim/colors/
  vim +PluginInstall +qall
fi

if [[ "${OS_FAMILY}" == "macos" ]] && [[ ! -f ~/Library/KeyBindings/DefaultKeyBinding.dict ]]; then
  msg "Fixing Mac's stupid Home and End keys..."
  mkdir -p ~/Library/KeyBindings/
  cp ${DIR}/files/Mac_home_end_keybindings.dict ~/Library/KeyBindings/DefaultKeyBinding.dict
fi


if [[ ! -d ${DIR}/hosted/powerline-fonts ]]; then
  msg "Patching fonts for powerline"
  install_hosted powerline-fonts https://github.com/powerline/fonts.git
  chmod +x ${DIR}/hosted/powerline-fonts/install.sh
  bash ${DIR}/hosted/powerline-fonts/install.sh > "${LOG_DIR}/powerline-fonts_install-script"
fi

if [[ ! -f ~/.gitignore ]]; then
  msg "Setting up global gitignore..."
  cat > ~/.gitignore <<-EOM
# IntelliJ Project files
*.iml
.idea/

# Stupid mac file
.DS_Store
EOM
  git config --global core.excludesfile ~/.gitignore
  git config --global user.name Justin Dipierro
  git config --global user.email dipierroj@gmail.com
  git config --global alias.fucked "push --force"
fi

if [[ ! -f ~/.curlrc ]]; then
  echo "Configuring Curl..."
  echo '-w "\n"' > ~/.curlrc
  cat > ~/.tcurl-format <<EOM
\n
%{url_effective}:\n
    time_namelookup:  %{time_namelookup}\n
       time_connect:  %{time_connect}\n
    time_appconnect:  %{time_appconnect}\n
   time_pretransfer:  %{time_pretransfer}\n
      time_redirect:  %{time_redirect}\n
 time_starttransfer:  %{time_starttransfer}\n
                    ----------\n
         time_total:  %{time_total}\n
       http_version:  %{http_version}\n
          http_code:  %{http_code}\n
EOM
fi

echo "--__--**^^**--__-- Finished setting up the environment! --__--**^^**--__--"
echo "__--__vv**vv__--__      Keep calm and Spork along!      __--__vv**vv__--__"
