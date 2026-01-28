{ ... }:
{
  programs.nixvim.plugins.lsp = {
    enable = true;

    servers = {
      pyright = {
        enable = true;
        settings = {
          python.analysis.typeCheckingMode = "off";
        };
      };

      ruff.enable = true;

      ts_ls.enable = true;

      jsonls.enable = true;

      rust_analyzer = {
        enable = true;
        installCargo = true;
        installRustc = true;
      };

      eslint.enable = true;

      gopls.enable = true;

      lua_ls = {
        enable = true;
        settings.Lua.completion.callSnippet = "Replace";
      };

      nixd.enable = true;
    };
  };
}
