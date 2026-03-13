{ pkgs, ... }:
{
  home.packages = [
    pkgs.claude-code
    pkgs.jq # Required for statusline script
  ];

  home.sessionVariables = {
    CLAUDE_CODE_SKIP_NPM_CHECK = "1";
  };
}
