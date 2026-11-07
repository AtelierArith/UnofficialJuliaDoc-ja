```julia
candidates(state::SelectorState, rows::Int) -> (; active::CandsState, gathered::CandsState)
```

表示用に、アクティブなエントリと収集済みエントリの表示可能なスライスを計算します。
