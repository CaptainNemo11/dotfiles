export TERMINAL=kitty
# Use nvim/emacs as the editor
if [[ -n "$INSIDE_EMACS" ]]; then
  export EDITOR='emacsclient'
  export VISUAL='emacsclient'
else
  export EDITOR='nvim'
  export VISUAL='nvim'
fi

#firefox
export MOZ_USE_XINPUT2=1 

#gcc colors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export PATH=/home/hl/.local/bin/:$PATH

#local texlive
export MANPATH=/home/hl/.local/texlive/2024/texmf-dist/doc/man:$MANPATH
export INFOPATH=/home/hl/.local/texlive/2024/texmf-dist/doc/info:$INFOPATH
export PATH=/home/hl/.local/texlive/2024/bin/x86_64-linux:$PATH
export TEXLIVE_INSTALL_NO_DISKCHECK=1

#npm
#. ~/.nvm/nvm.sh
export npm_config_prefix="$HOME/.local"

export PATH=/opt/clang-format-static:$PATH

#questa
export PATH=~/.local/altera/24.1std/questa_fse/bin/:$PATH
export LM_LICENSE_FILE=~/.license/LR-249748_License.dat:$LM_LICENSE_FILE

#cmake
export CMAKE_BUILD_PARALLEL_LEVEL=4
export CMAKE_EXPORT_COMPILE_COMMANDS=1

#rust
. "$HOME/.cargo/env"
export CARGO_BUILD_JOBS=4


#cuda
#export CUDA_VISIBLE_DEVICES=0

#export DELTA_FEATURES=+light-mode
#export BAT_THEME=light
export DFT_BACKGROUND=light

#hs
. "$HOME/.ghcup/env" 

#proxy 
alias clash="bash /usr/share/ShellCrash/menu.sh"
export CRASHDIR="/usr/share/ShellCrash"

#android phone(kde)
export MY_PHONE_NAME="hl_phone_p40"

#export GROFF_SGR=1

#perl
export PATH="/home/hl/perl5/bin${PATH:+:${PATH}}"
export PERL5LIB="/home/hl/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"
export PERL_LOCAL_LIB_ROOT="/home/hl/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"
export PERL_MB_OPT="--install_base \"/home/hl/perl5\""
export PERL_MM_OPT="INSTALL_BASE=/home/hl/perl5"

#lean4
export PATH="$HOME/.elan/bin:$PATH"

#ocaml
. "/home/hl/.opam/opam-init/init.sh"
