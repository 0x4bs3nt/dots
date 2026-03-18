{ pkgs, lib, ... }:
{
  home.packages = [
    pkgs.nodejs
    pkgs.jq # Required for statusline script
  ];

  home.sessionVariables = {
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
    CLAUDE_CODE_SKIP_NPM_CHECK = "1";
  };

  home.sessionPath = [
    "$HOME/.npm-global/bin"
  ];

  # Install latest claude-code from npm on every home-manager switch
  home.activation.installClaudeCode = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export PATH="${pkgs.nodejs}/bin:$PATH"
    export NPM_CONFIG_PREFIX="$HOME/.npm-global"
    $DRY_RUN_CMD mkdir -p "$HOME/.npm-global"
    $DRY_RUN_CMD ${pkgs.nodejs}/bin/npm install -g @anthropic-ai/claude-code@latest 2>/dev/null || true
  '';
}
