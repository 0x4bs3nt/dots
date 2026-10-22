{ pkgs, ... }:
{
  users.users.absent = {
    isNormalUser = true;
    description = "absent";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
}
