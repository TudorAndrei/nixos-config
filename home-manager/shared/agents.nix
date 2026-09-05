{
  lib,
  pkgs,
  ...
}: let
  buildAgentFile = name: parts:
    pkgs.writeText name (
      lib.concatStringsSep "\n" (
        lib.filter (part: part != "") (map builtins.readFile parts)
      )
    );

  claudeInstructions = buildAgentFile "CLAUDE.md" [
    ./agents/CLAUDE_HEADER.md
    ./agents/COMMON.md
    ./agents/CLAUDE_FOOTER.md
  ];

  codexInstructions = buildAgentFile "AGENTS.md" [
    ./agents/AGENTS_HEADER.md
    ./agents/COMMON.md
    ./agents/AGENTS_FOOTER.md
  ];
in {
  home.activation.agentInstructions = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run mkdir -p "$HOME/.claude" "$HOME/.codex"
    run rm -f "$HOME/.claude/CLAUDE.md" "$HOME/.codex/AGENTS.md"
    run install -m 644 ${claudeInstructions} "$HOME/.claude/CLAUDE.md"
    run install -m 644 ${codexInstructions} "$HOME/.codex/AGENTS.md"
  '';
}
