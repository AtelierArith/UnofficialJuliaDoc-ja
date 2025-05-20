```
endswith(suffix)
```

引数が`suffix`で終わるかどうかをチェックする関数を作成します。すなわち、`y -> endswith(y, suffix)`と同等の関数です。

返される関数は`Base.Fix2{typeof(endswith)}`型であり、特化したメソッドを実装するために使用できます。

!!! compat "Julia 1.5"
    単一引数`endswith(suffix)`は、少なくともJulia 1.5が必要です。


# 例

```jldoctest
julia> endswith("Julia")("Ends with Julia")
true

julia> endswith("Julia")("JuliaLang")
false
```
