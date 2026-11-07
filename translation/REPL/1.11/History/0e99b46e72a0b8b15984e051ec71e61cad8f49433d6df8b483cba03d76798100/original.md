```julia
clipboard_available(props::REPL.LineEdit.TerminalProperties) -> Bool
```

Return `true` if clipboard saving is possible, either via system clipboard commands or via OSC 52 terminal escape sequences.
