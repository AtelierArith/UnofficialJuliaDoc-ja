```julia
endswith(suffix)
```

引数が `suffix` で終わるかどうかを判定する関数を作成します。つまり、`y -> endswith(y, suffix)` と同等の関数です。

返される関数の型は `Base.Fix2{typeof(endswith)}` であり、これを使って特化メソッドを実装できます。

!!! compat "Julia 1.5"
    引数が1つの `endswith(suffix)` は、Julia 1.5以降で使用できます。


# Examples

```jldoctest
julia> endswith("Julia")("Ends with Julia")
true

julia> endswith("Julia")("JuliaLang")
false
```
