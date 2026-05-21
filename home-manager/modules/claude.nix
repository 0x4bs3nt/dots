{
  config,
  pkgs,
  lib,
  ...
}:
let
  npmPrefix = "${config.home.homeDirectory}/.npm-global";
  statuslineScript = "${config.home.homeDirectory}/.claude/statusline-command.sh";
in
{
  home.packages = [
    pkgs.nodejs
    pkgs.jq # Required for statusline script
    pkgs.curl # Required for statusline script
  ];

  home.sessionVariables = {
    NPM_CONFIG_PREFIX = npmPrefix;
    CLAUDE_CODE_SKIP_NPM_CHECK = "1";
  };

  # Add npm global bin to PATH via fish directly
  programs.fish.shellInit = ''
    fish_add_path "${npmPrefix}/bin"
  '';

  # Deploy the statusline script to ~/.claude/statusline-command.sh
  home.file.".claude/statusline-command.sh" = {
    source = ./claude/statusline-command.sh;
    executable = true;
  };

  # Install latest claude-code from npm on every home-manager switch
  home.activation.installClaudeCode = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export PATH="${pkgs.nodejs}/bin:$PATH"
    export NPM_CONFIG_PREFIX="${npmPrefix}"
    $DRY_RUN_CMD mkdir -p "${npmPrefix}"
    $DRY_RUN_CMD ${pkgs.nodejs}/bin/npm install -g @anthropic-ai/claude-code@latest
  '';

  # Merge the statusLine config into Claude's settings.json without
  # clobbering keys Claude itself writes (theme, effortLevel, etc.).
  home.activation.claudeStatuslineConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    SETTINGS="${config.home.homeDirectory}/.claude/settings.json"
    $DRY_RUN_CMD mkdir -p "${config.home.homeDirectory}/.claude"
    [ -f "$SETTINGS" ] || $DRY_RUN_CMD echo '{}' > "$SETTINGS"
    TMP=$(mktemp)
    ${pkgs.jq}/bin/jq --arg cmd "${statuslineScript}" \
      '.statusLine = {type: "command", command: $cmd}' \
      "$SETTINGS" > "$TMP" && $DRY_RUN_CMD mv "$TMP" "$SETTINGS"
  '';
}
