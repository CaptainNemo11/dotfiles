# Use nvim as the editor
export EDITOR=nvim

#gcc colors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

#local texlive
export MANPATH=/home/hl/.local/texlive/2024/texmf-dist/doc/man:$MANPATH
export INFOPATH=/home/hl/.local/texlive/2024/texmf-dist/doc/info:$INFOPATH
export PATH=/home/hl/.local/texlive/2024/bin/x86_64-linux:$PATH
export TEXLIVE_INSTALL_NO_DISKCHECK=1

#npm
export PATH=~/.npm-global/bin:$PATH
