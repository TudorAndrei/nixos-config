{pkgs, ...}: {
  programs.git = {
    enable = true;
    userName = "TudorAndrei";
    userEmail = "tudorandrei.dumitrascu@gmail.com";
    extraConfig = {
      # core.pager = "delta";
      # interactive.diffFilter = "delta --color-only";
      # delta.navigate = true;
      # delta.dark = true;
      merge.conflictstyle = "zdiff3";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      filter = {
        clean = "git-lfs clean -- %f";
        smudge = "git-lfs smudge -- %f";
        process = "git-lfs filter-process";
        required = true;
      };
      core.excludefile = "~/.gitignore_global";
      github.user = "TudorAndrei";
    };
    includes = [
      {
        condition = "gitdir:~/pythia/";
        path = "~/pythia/.gitconfig-pythia";
      }
    ];
  };
}
