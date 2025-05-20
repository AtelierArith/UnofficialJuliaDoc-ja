```
minimum(itr; [init])
```

コレクション内の最小要素を返します。

空の `itr` に対して返される値は `init` によって指定できます。これは `min` に対して中立的な要素でなければなりません（すなわち、他のどの要素よりも大きいか等しいものでなければなりません）。`init` が非空のコレクションに対して使用されるかどうかは未定義です。

!!! compat "Julia 1.6"
    キーワード引数 `init` は Julia 1.6 以降が必要です。


# 例

```jldoctest
julia> minimum(-20.5:10)
-20.5

julia> minimum([1,2,3])
1

julia> minimum([])
ERROR: ArgumentError: reducing over an empty collection is not allowed; consider supplying `init` to the reducer
Stacktrace:
[...]

julia> minimum([]; init=Inf)
Inf
```
