```julia
saveclipboard(term::Base.Terminals.TTYTerminal, content::AbstractString,
              props::REPL.LineEdit.TerminalProperties)
```

Save `content` to the clipboard and record the action. Falls back to OSC 52 terminal escape sequences when no system clipboard command is available.
