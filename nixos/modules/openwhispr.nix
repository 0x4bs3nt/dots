{ ... }:
{
  # OpenWhispr uses ydotool to auto-paste/type transcriptions into other apps.
  # On Wayland this needs the ydotoold daemon (run here as a hardened system
  # service) plus access to /dev/uinput. The module exposes the socket at
  # /run/ydotoold/socket and exports YDOTOOL_SOCKET so OpenWhispr can find it.
  # Users must be in the "ydotool" group (see users.users.<name>.extraGroups).
  programs.ydotool.enable = true;
}
