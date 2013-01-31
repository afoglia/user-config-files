# Turn off trackpad when typing
syndaemon -d -i 1 -k

if [ -f "$HOME/.xinitrc.local" ] ; then
  . "$HOME/.xinitrc.local"
fi
