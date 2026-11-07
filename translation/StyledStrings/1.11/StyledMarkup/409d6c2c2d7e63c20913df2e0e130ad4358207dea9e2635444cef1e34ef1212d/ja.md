```julia
readexpr!(state::State, pos::Int = first(popfirst!(state.s)) + 1)
```

`state.content`内の`pos`から始まる式を読み取り、イテレーターを式の末尾に合わせるため、必要に応じて`state.s`を消費します。
