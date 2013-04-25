# Turn off trackpad when typing
if command -v syndaemon > /dev/null 2>&1 ; then
  syndaemon -d -i 1 -k
fi

if [ -f "$HOME/.xinitrc.local" ] ; then
  . "$HOME/.xinitrc.local"
fi
