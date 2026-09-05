{
  config,
  lib,
  pkgs,
  ...
}: let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;

  platformInit =
    if isDarwin
    then ./zsh/darwin.zsh
    else ./zsh/linux.zsh;

  platformAliases =
    if isDarwin
    then {
      nds = "sudo darwin-rebuild switch --flake ~/nixos-config#piticu";
    }
    else {
      nos = "nh os switch";
      nhs = "home-manager switch --flake .#tudor";
      rwb = "killall -SIGUSR2 .waybar-wrapped";
      rhl = "hyprctl reload";
    };
in {
  programs.zsh = {
    enable = true;
    enableCompletion = false;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;

    history = {
      size = 10000;
      save = 10000;
      path = "${config.xdg.stateHome}/zsh/history";
      share = true;
    };

    plugins = [
      {
        name = "zsh-defer";
        src = pkgs.zsh-defer;
        file = "share/zsh-defer/zsh-defer.plugin.zsh";
      }
    ];

    shellAliases =
      {
        mt = "mise tasks";
        n = "nvim";
        vi = "nvim";
        vim = "nvim";
        ff = "fastfetch";
        afz = "alias | fzf";
        rcp = "rsync -r --info=progress2 --info=name0";
        speedtest = "curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -";
        bigfiles = "du -hs $(ls -A) | sort -rh | head -5";
        k = "eza --long --git";
        sv = "source .venv/bin/activate";
        dcu = "docker compose up";
        dcud = "docker compose up -d";
        dcd = "docker compose down";
        ".." = "cd ..";
        oc = "opencode";
        cterra = "codex -m gpt-5.6-terra";
        csol = "codex -m gpt-5.6-sol";
        copus = "claude --model opus";
        cfab = "claude --model fable";
        cson = "claude --model sonnet";
        wget = "curl -LO";
        tns = "tmux new -s $(basename $PWD)";
        hns = "herdr workspace create --cwd \"$PWD\" --label \"$(basename $PWD)\" --focus";
        ltmux = "tmux -L lazytmux -f $HOME/cave/LazyTmux/lazytmux.tmux new-session -A -s lazytmux";
        gput = "python -c 'import torch;print(torch.cuda.is_available())'";
        gputf = "python -c 'import tensorflow as tf;tf.config.list_physical_devices()'";
      }
      // platformAliases;

    initContent = lib.mkMerge [
      (builtins.readFile ./zsh/init.zsh)
      (builtins.readFile platformInit)
    ];
  };

  home.activation.zshStateDirectory = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run mkdir -p "${config.xdg.stateHome}/zsh"
  '';
}
