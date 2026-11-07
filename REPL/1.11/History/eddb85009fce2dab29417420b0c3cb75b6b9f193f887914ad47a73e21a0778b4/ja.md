```julia
update_candidates(io::IO, oldcands::CandsState, newcands::CandsState, force::Bool = false)
```

表示を`oldcands`から`newcands`に変更する更新を`io`に記述してください。

変更箇所のみが出力され、出力される行数はちょうど`length(newcands.entries)`行です。
