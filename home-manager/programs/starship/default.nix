_: {
  programs.starship = {
    enable = true;
    settings = {
      character = {
        error_symbol = "[λ](bold #ff5555)";
        success_symbol = "[λ](bold #50fa7b)";
      };

      hostname.style = "bold #bd93f9";

      username = {
        format = "\\[[$user]($style)\\]";
        style_user = "bold #8be9fd";
      };
      battery = {
        disabled = true;
      };

      directory = {
        truncation_length = 5;
        style = "bold #50fa7b";
        format = "[$path]($style)[$lock_symbol]($lock_style) ";
      };

      custom = {
        git_scope = {
          command = ''
            printf "%s" \
              "$(if [ -n "$GIT_AUTHOR_NAME" ]; then echo "$GIT_AUTHOR_NAME"; else git config user.name; fi)"
          '';
          format = " as [$output]($style) ";
          shell = ["zsh"];
          style = "blue bold";
          when = "git rev-parse --is-inside-work-tree";
        };
      };
    };
    # [directory]
    # truncation_length = 5
    # style = "bold #50fa7b"
    # format = "[$path]($style)[$lock_symbol]($lock_style) "
    #
    # [git_branch]
    # symbol = " "
    # truncation_length = 10
    # truncation_symbol = ""
    # style = "bold #ff79c6"
    # format = '\[[$symbol$branch]($style)\]'
    #
    # [git_commit]
    # commit_hash_length = 4
    # tag_symbol = "🔖 "
    #
    #
    # [git_status]
    # ahead = "⇡${count}"
    # diverged = "⇕⇡${ahead_count}⇣${behind_count}"
    # behind = "⇣${count}"
    # format = '([\[$all_status$ahead_behind\]]($style))'
    # style = "bold #ff5555"
  };
}
