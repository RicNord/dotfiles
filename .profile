
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    export PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Enviorment variables
#
# set chrome as browser
if [ -f /usr/bin/google-chrome-stable ]; then
    export BROWSER=/usr/bin/google-chrome-stable
fi

# set nvim as editor and visual
if [ -f /usr/bin/nvim ]; then
    export EDITOR=/usr/bin/nvim
    export VISUAL=/usr/bin/nvim
fi
