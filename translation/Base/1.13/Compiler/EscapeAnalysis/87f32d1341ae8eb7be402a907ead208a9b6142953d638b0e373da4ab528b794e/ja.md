```julia
estate::EscapeState
```

引数とSSA値を、[`EscapeInfo`](@ref)で表されるエスケープ情報に対応付ける拡張ラティスです。SSA IR要素`x`に課されたエスケープ情報は、`estate[x]`で取得できます。
