```julia
startswith(prefix)
```

引数が `prefix` で始まるかどうかをチェックする関数を作成します。つまり、`y -> startswith(y, prefix)` と同等の関数です。

返される関数は `Base.Fix2{typeof(startswith)}` 型であり、特化したメソッドを実装するために使用できます。

!!! compat "Julia 1.5"
    単一引数 `startswith(prefix)` は少なくとも Julia 1.5 が必要です。


# 例

```jldoctest
julia> startswith("Julia")("JuliaLang")
true

julia> startswith("Julia")("Ends with Julia")
false
```
