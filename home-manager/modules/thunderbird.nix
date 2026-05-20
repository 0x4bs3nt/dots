{ pkgs, ... }:
{
  programs.thunderbird = {
    enable = true;
    profiles.absent = {
      isDefault = true;
    };
  };
}
