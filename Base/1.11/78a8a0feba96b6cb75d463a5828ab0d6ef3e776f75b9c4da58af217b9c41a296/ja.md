```
startswith(prefix)
```

`prefix`で始まるかどうかをチェックする関数を作成します。つまり、`y -> startswith(y, prefix)`に相当する関数です。

返される関数は`Base.Fix2{typeof(startswith)}`型であり、特化したメソッドを実装するために使用できます。

!!! compat "Julia 1.5"
    単一引数`startswith(prefix)`は、少なくともJulia 1.5が必要です。


# 例

```jldoctest
julia> startswith("Julia")("JuliaLang")
true

julia> startswith("Julia")("Ends with Julia")
false
```
