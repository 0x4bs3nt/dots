{ pkgs, ... }:
{
  home.packages = [ pkgs.fastfetch ];

  xdg.configFile."fastfetch/config.jsonc".text = ''
    {
      "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
      "logo": {
        "type": "small",
        "padding": {
          "top": 2,
          "left": 2
        }
      },
      "display": {
        "separator": " ➜  ",
        "color": {
            "keys": "magenta"
        }
      },
      "modules": [
        "title",
        "separator",
        {
          "type": "os",
          "key": "os  ",
          "keyColor": "31" 
        },
        {
          "type": "kernel",
          "key": "ker ",
          "keyColor": "32"
        },
        {
          "type": "shell",
          "key": "sh  ",
          "keyColor": "34"
        },
        {
          "type": "uptime",
          "key": "up  ",
          "keyColor": "36"
        },
        "break",
        {
          "type": "cpu",
          "key": "cpu ",
          "keyColor": "33"
        },
        {
          "type": "gpu",
          "key": "gpu ",
          "keyColor": "35"
        },
        {
          "type": "memory",
          "key": "mem ",
          "keyColor": "32"
        },
        "break",
        {
          "type": "colors",
          "symbol": "circle"
        }
      ]
    }
  '';
}
