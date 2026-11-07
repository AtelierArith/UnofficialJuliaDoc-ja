```julia
saveclipboard(term::Base.Terminals.TTYTerminal, content::AbstractString,
              props::REPL.LineEdit.TerminalProperties)
```

`content`をクリップボードに保存し、その操作を記録します。システムのクリップボードコマンドが利用できない場合は、OSC 52のターミナルエスケープシーケンスにフォールバックします。
