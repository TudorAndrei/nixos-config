{config, ...}: {
  programs.zsh = {
    # PERF: Use to debug performance
    # zprof.enable = true;
    enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;
    enableCompletion = true;
    initContent = ''
      pdfcompress ()
      {
        gs -q -dNOPAUSE -dBATCH -dSAFER -sDEVICE=pdfwrite -dCompatibilityLevel=1.3 -dPDFSETTINGS=/screen -dEmbedAllFonts=true -dSubsetFonts=true -dColorImageDownsampleType=/Bicubic -dColorImageResolution=144 -dGrayImageDownsampleType=/Bicubic -dGrayImageResolution=144 -dMonoImageDownsampleType=/Bicubic -dMonoImageResolution=144 -sOutputFile=$\{1%.*\}.compressed.pdf $1;
      }
      screengrab() {
        VIDDIR=$HOME/Videos/Screengrabs
          [ ! -d "$VIDDIR" ] && mkdir "$VIDDIR"
          RES=$(xrandr |grep \* | awk '{print $1}')
            ffmpeg -y -f x11grab -video_size "$RES" -framerate 30 -i :0.0 -f pulse -ac 2 -i 0 -c:v libx264 -pix_fmt yuv420p -s "$RES" -preset ultrafast -c:a libfdk_aac -b:a 128k -threads 0 -strict normal -bufsize 2000k "$VIDDIR"/"$1".mp4
      }
    '';
    shellAliases = {
      # nhs = "nh home switch";
      nhs = "home-manager switch --flake .#tudor";
      nos = "nh os switch";
      n = "nvim";
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
      rwb = "killall -SIGUSR2 .waybar-wrapped";
      rhl = "hyprctl reload";
      opencode = "npx opencode";
      ".." = "cd ..";
      # GPU
      gput = "python -c 'import torch;print(torch.cuda.is_available())'";
      gputf = "python -c 'import tensorflow as tf;tf.config.list_physical_devices()'";
      # WireGuard
      wg-status = "sudo wg show";
      wg-start = "sudo systemctl start wireguard-wg0.service";
      wg-stop = "sudo systemctl stop wireguard-wg0.service";
      wg-restart = "sudo systemctl restart wireguard-wg0.service";
      wg-ui = "xdg-open http://localhost:5000";
      wg-start-ui = "wireguard-ui";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
      share = true;
    };
  };
}
