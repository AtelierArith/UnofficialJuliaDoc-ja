```julia
estate::EscapeState
```

引数とSSA値を[`EscapeInfo`](@ref)として表現されたエスケープ情報にマッピングする拡張ラティス。SSA IR要素`x`に課せられたエスケープ情報は`estate[x]`で取得できます。
