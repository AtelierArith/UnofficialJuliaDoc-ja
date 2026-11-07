```julia
endswith(suffix)
```

引数が `suffix` で終わるかどうかを判定する関数を作成します。つまり、`y -> endswith(y, suffix)` と同等の関数です。

返される関数の型は `Base.Fix2{typeof(endswith)}` で、これを使って特化メソッドを実装できます。

!!! compat "Julia 1.5"
    引数を1つ取る `endswith(suffix)` は、Julia 1.5 以降で利用できます。


# Examples

```jldoctest
julia> endswith("Julia")("Ends with Julia")
true

julia> endswith("Julia")("JuliaLang")
false
```
