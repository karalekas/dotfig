################################################################################
# Usage: KEY=theme LINE='theme = "gruvbox-dark"' awk -f tui-key.awk config.toml
#
# Print config.toml with $KEY in its [tui] table replaced by $LINE, adding the
# table if there isn't one. An empty $LINE removes the key, and the table too
# if nothing else is left in it (so restore.sh can undo an added table). Used
# by install.sh and restore.sh, which can't rely on a TOML-aware tool.
################################################################################

BEGIN { key_pattern = "^" ENVIRON["KEY"] "[ \t]*=" }

# blank lines are held until the next line shows whether they're needed: the
# ones before an emptied [tui] table go with it
function flush() { printf "%s", blanks; blanks = "" }

/^[ \t]*$/ {
  if (held) held_blanks = held_blanks $0 "\n"
  else blanks = blanks $0 "\n"
  next
}

/^\[/ {
  # emptied [tui] table: drop it, keeping the blank lines that separated it
  if (held) { held = 0; held_blanks = ""; blanks = held_header_blanks }
  in_tui = ($0 == "[tui]")
}

# drop the old value; it's printed again (or not) right after the header
in_tui && $0 ~ key_pattern { next }

$0 == "[tui]" {
  seen_tui = 1
  if (ENVIRON["LINE"] != "") { flush(); print; print ENVIRON["LINE"] }
  else { held = 1; held_header_blanks = blanks; blanks = "" }
  next
}

{
  if (held) {
    printf "%s[tui]\n%s", held_header_blanks, held_blanks
    held = 0; held_blanks = ""
  }
  flush()
  print
}

END {
  if (!held) flush()
  if (!seen_tui && ENVIRON["LINE"] != "") printf "\n[tui]\n%s\n", ENVIRON["LINE"]
}
