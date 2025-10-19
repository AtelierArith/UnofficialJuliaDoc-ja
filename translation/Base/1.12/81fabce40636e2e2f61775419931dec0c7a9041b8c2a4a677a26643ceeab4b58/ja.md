```julia
maximum(itr; [init])
```

コレクション内の最大の要素を返します。

空の `itr` に対して返される値は `init` によって指定できます。これは `max` にとって中立的な要素でなければなりません（すなわち、他のどの要素よりも小さいか等しい必要があります）。`init` が非空のコレクションに対して使用されるかどうかは未定義です。

!!! compat "Julia 1.6"
    キーワード引数 `init` は Julia 1.6 以降が必要です。


# 例

```jldoctest
julia> maximum(-20.5:10)
9.5

julia> maximum([1,2,3])
3

julia> maximum(())
ERROR: ArgumentError: empty collection に対しての還元は許可されていません; reducer に `init` を供給することを検討してください
Stacktrace:
[...]

julia> maximum((); init=-Inf)
-Inf
```
