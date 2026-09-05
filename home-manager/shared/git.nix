{
  lib,
  pkgs,
  ...
}: let
  gpg =
    if pkgs.stdenv.hostPlatform.isDarwin
    then "/opt/homebrew/bin/gpg"
    else "${pkgs.gnupg}/bin/gpg";
in {
  programs.git = {
    enable = true;
    lfs.enable = true;

    userName = "TudorAndrei";
    userEmail = "tudorandrei.dumitrascu@gmail.com";

    signing = {
      format = "openpgp";
      key = "942B3E71D73EADFB";
      signer = gpg;
    };

    ignores = lib.filter (line: line != "") (
      lib.splitString "\n" (builtins.readFile ./git/gitignore_global)
    );

    settings = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
      merge.conflictstyle = "zdiff3";
      core.untrackedCache = true;
      github.user = "TudorAndrei";
    };

    includes = [
      {
        condition = "gitdir:~/pythia/";
        contents = {
          user = {
            name = "TudorAndrei-Pythia";
            email = "tudor@pythia.social";
          };
          github.user = "TudorAndrei-Pythia";
          url."pythia".insteadOf = "git@github.com";
        };
      }
      {
        condition = "gitdir:~/cave/";
        contents = {
          user = {
            name = "TudorAndrei";
            email = "tudorandrei.dumitrascu@gmail.com";
          };
          github.user = "TudorAndrei";
          url."personal".insteadOf = "github.com";
          core.sshCommand = "ssh -i ~/.ssh/github";
        };
      }
      {
        condition = "gitdir:~/cave/footprints/";
        contents.commit.gpgsign = true;
      }
      {
        condition = "gitdir:~/work/";
        contents = {
          user = {
            name = "Tudor Dumitrascu";
            email = "tudor.dumitrascu@cogni-sync.com";
            username = "tudor.dumitrascu";
          };
          github.user = "tudordumitrascu-cognisync";
          url."cognisync".insteadOf = "git@github.com";
        };
      }
    ];
  };
}
