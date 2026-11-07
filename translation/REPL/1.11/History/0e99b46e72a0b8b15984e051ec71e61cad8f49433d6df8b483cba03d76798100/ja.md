```julia
clipboard_available(props::REPL.LineEdit.TerminalProperties) -> Bool
```

クリップボードへの保存が可能な場合は、システムのクリップボードコマンドまたは OSC 52 ターミナルエスケープシーケンスを使って、`true` を返してください。
