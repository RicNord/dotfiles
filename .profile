
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Enviorment variables
#
# set firefox as browser
if [ -f /usr/bin/firefox ]; then
    export BROWSER=/usr/bin/firefox
# ubuntu specific
elif [ -f /snap/bin/firefox ]; then
    export BROWSER=/snap/bin/firefox
fi

# set nvim as editor and visual
if [ -f /usr/bin/nvim ]; then
    export EDITOR=/usr/bin/nvim
    export VISUAL=/usr/bin/nvim
fi
