{ pkgs, ... }:
{
  users.users.absent = {
    isNormalUser = true;
    description = "absent";
    extraGroups = [
      "networkmanager"
      "wheel"
      "ydotool" # access the ydotoold socket (OpenWhispr auto-paste)
      "input" # OpenWhispr checks for input-group membership on Wayland
    ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
}
