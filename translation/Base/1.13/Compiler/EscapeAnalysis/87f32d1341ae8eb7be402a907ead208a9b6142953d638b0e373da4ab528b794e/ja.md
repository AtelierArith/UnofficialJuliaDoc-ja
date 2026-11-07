```julia
estate::EscapeState
```

引数とSSA値をエスケープ情報に対応付ける拡張ラティス。エスケープ情報は[`EscapeInfo`](@ref)として表されます。SSA IR要素`x`に設定されたエスケープ情報は、`estate[x]`で取得できます。
