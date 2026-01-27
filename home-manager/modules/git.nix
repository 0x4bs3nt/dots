{ ... }: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "0x4bs3nt";
        email = "hi@4bs3nt.com";
      };
    };
  };
}
