#!/usr/bin/env bash

DEBUG=
function debug() { if [ "${DEBUG}" ]; then echo $1; fi }
debug "Debugging Enabled"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

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
  echo "Installing ${PKG}..."
  case $(uname -a) in
    Darwin )
      brew install ${PKG} > /dev/null 2>&1;;
    *fc[0-9][0-9]* )
      sudo yum install -y ${PKG} > /dev/null 2>&1;;
    * )
      echo "ERROR: Don't know how to install on this system."
      exit 1;;
  esac
  if [ "$?" ]; then
    debug "Error installing ${PKG}. Please attempt to fix manually."
    exit 1
  fi
}

function install_hosted() {
  HOSTED_PKG=$1
  GIT_URL=$2
  mkdir -p ${DIR}/hosted
  if [ ! -d "${DIR}/hosted/${HOSTED_PKG}" ]; then
    echo "Installing ${HOSTED_PKG}..."
    git clone ${GIT_URL} ${DIR}/hosted/${HOSTED_PKG} >/dev/null 2>&1
  fi
}

# Make sure Homebrew is installed if we're on a mac.
if [ "$(uname)" == "Darwin" ]; then
  if ! brew --version > /dev/null 2>&1; then
    echo "Installing Homebrew..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" > /dev/null 2>&1
  fi
fi

# Set up awesome things
install zsh
if ! [ -d ~/.oh-my-zsh/ ]; then
  echo "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  echo "Installing custom ZSH theme..."
  cp ${DIR}/files/jdipierro.zsh-theme ~/.oh-my-zsh/themes/
fi
install thefuck
install_hosted z https://github.com/rupa/z.git
install_hosted zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git

echo "Setting custom ZSHRC..."
cat > ~/.zshrc <<- EOM
  source ${DIR}/zshrc
  source ${DIR}/aliases
EOM

cat << EOM
                                            ,,_
                                g@L  ,     ,J@[Q@.,,gD*%k        ,,
                               J@QFS@*%kw#SE@p ;; @P    ?@,    ,@E2k
         ,^^^^^^^.              ^@2@E  SE^@Q@    {P.,w,  SBB@BP*.@U@.
        ;@ VVVVV B@L              JULg@kBFSE      @@*^%Zk?*    ,#E@F
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
