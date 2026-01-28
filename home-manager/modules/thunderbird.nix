{ pkgs, ... }:
{
  programs.thunderbird = {
    enable = true;
    profiles.jan = {
      isDefault = true;
    };
  };
}
