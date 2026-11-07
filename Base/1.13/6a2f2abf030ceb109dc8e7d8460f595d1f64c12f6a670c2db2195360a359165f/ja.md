```julia
startswith(prefix)
```

引数が `prefix` で始まるかどうかを判定する関数を作成します。つまり、`y -> startswith(y, prefix)` と同等の関数です。

返される関数の型は `Base.Fix2{typeof(startswith)}` で、これを使って特化メソッドを実装できます。

!!! compat "Julia 1.5"
    引数が1つの `startswith(prefix)` を使うには、Julia 1.5以降が必要です。


# Examples

```jldoctest
julia> startswith("Julia")("JuliaLang")
true

julia> startswith("Julia")("Ends with Julia")
false
```
