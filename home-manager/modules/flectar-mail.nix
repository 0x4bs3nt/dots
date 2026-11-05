{ pkgs, ... }:
{
  home.packages = [ (pkgs.callPackage ../../packages/flectar-mail.nix { }) ];
}
