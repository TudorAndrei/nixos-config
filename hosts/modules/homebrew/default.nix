_: {
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "uninstall";
    };

    taps = [
      "acsandmann/tap"
    ];

    brews = [
      "pinentry-mac"
      "gnupg"
      "postgresql@17"
      "lsof"
      "mlx-lm"
      "mole"
      "qemu"
      "sox"
      "switchaudio-osx"
      "tig"
      "unar"
      "acsandmann/tap/menuanywhere"
      "ampcode/tap/ampcode"
      "tudorandrei/barrs/barrs"
      "tudorandrei/muzik/muzik"
      "ffmpeg"
      "ghostscript"
      "imagemagick"
      "tectonic"
      "watchman"
      "wget"
      "sshfs"
    ];

    casks = [
      "anki"
      "anydesk"
      "antigravity"
      "antigravity-ide"
      "bitwarden"
      "blackhole-2ch"
      "block-buzz"
      "caffeine"
      "claude"
      "cursor"
      "dbx"
      "discord"
      "crmne/tap/fastpotify"
      "fluidvoice"
      "ghostty"
      "google-chrome"
      "helium-browser"
      "iina"
      "linear"
      "localsend"
      "love"
      "mactex-no-gui"
      "grishka/grishka/neardrop"
      "netbirdio/tap/netbird-ui"
      "ngrok"
      "obs"
      "petrichor"
      "obsidian"
      "orbstack"
      "protonvpn"
      "raycast"
      "signal"
      "slack"
      "spotify"
      "stats"
      "stremio"
      "studio-3t"
      "studio-3t-community"
      "syncthing-app"
      "t3-code"
      "telegram"
      "visual-studio-code"
      "vscodium"
      "zed"
      "zen"
      "sf-symbols"
      "zotero"
      "font-carlito"
      "font-fontawesome"
      "font-hack-nerd-font"
      "font-jetbrains-mono-nerd-font"
      "font-ioskeley-mono"
      "font-symbols-only-nerd-font"
    ];
  };
}
