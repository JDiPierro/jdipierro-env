export JDI_ENV_DIR="${${(%):-%N}:A:h}"
export ZSH="${HOME}/.oh-my-zsh"

ZSH_THEME="jdipierro"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
plugins=(git docker)

# Add my custom bin directory
export PATH="${PATH}:${HOME}/bin"

function source_first_available() {
  local config_file
  for config_file in "$@"; do
    if [[ -r "${config_file}" ]]; then
      source "${config_file}"
      return
    fi
  done
}

source_first_available "${ZSH}/oh-my-zsh.sh"

BREW_PREFIX=
if command -v brew >/dev/null 2>&1; then
  BREW_PREFIX="$(brew --prefix 2>/dev/null)"
fi

source_first_available \
  "${BREW_PREFIX:+${BREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh}" \
  /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source_first_available \
  "${BREW_PREFIX:+${BREW_PREFIX}/etc/profile.d/z.sh}" \
  /usr/share/z/z.sh \
  /usr/share/zsh/scripts/z.sh

unset BREW_PREFIX
unfunction source_first_available

if command -v kubectl >/dev/null 2>&1; then
  source <(kubectl completion zsh)
fi

if [[ -f ${HOME}/.aliases ]]; then
  source ${HOME}/.aliases
fi

function ferret() {
  echo "
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
                               3@.                         %@F;3S     ,@F"| lolcat
}
ferret
