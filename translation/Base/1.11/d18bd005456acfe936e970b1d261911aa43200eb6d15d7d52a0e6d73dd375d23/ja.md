```
maximum(itr; [init])
```

コレクション内の最大の要素を返します。

空の `itr` に対して返される値は `init` によって指定できます。これは `max` に対して中立的な要素でなければなりません（すなわち、他のどの要素よりも小さいか等しいものでなければなりません）。`init` が非空のコレクションに対して使用されるかどうかは未定義です。

!!! compat "Julia 1.6"
    キーワード引数 `init` は Julia 1.6 以降が必要です。


# 例

```jldoctest
julia> maximum(-20.5:10)
9.5

julia> maximum([1,2,3])
3

julia> maximum(())
ERROR: ArgumentError: reducing over an empty collection is not allowed; consider supplying `init` to the reducer
Stacktrace:
[...]

julia> maximum((); init=-Inf)
-Inf
```
