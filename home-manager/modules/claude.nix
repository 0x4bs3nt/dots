{ config, pkgs, lib, ... }:
let
  npmPrefix = "${config.home.homeDirectory}/.npm-global";
in
{
  home.packages = [
    pkgs.nodejs
    pkgs.jq # Required for statusline script
  ];

  home.sessionVariables = {
    NPM_CONFIG_PREFIX = npmPrefix;
    CLAUDE_CODE_SKIP_NPM_CHECK = "1";
  };

  # Add npm global bin to PATH via fish directly
  programs.fish.shellInit = ''
    fish_add_path "${npmPrefix}/bin"
  '';

  # Install latest claude-code from npm on every home-manager switch
  home.activation.installClaudeCode = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export PATH="${pkgs.nodejs}/bin:$PATH"
    export NPM_CONFIG_PREFIX="${npmPrefix}"
    $DRY_RUN_CMD mkdir -p "${npmPrefix}"
    $DRY_RUN_CMD ${pkgs.nodejs}/bin/npm install -g @anthropic-ai/claude-code@latest
  '';
}
