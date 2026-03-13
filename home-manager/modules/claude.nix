{ pkgs, ... }:
{
  home.packages = [
    pkgs.claude-code
    pkgs.jq # Required for statusline script
  ];
}
