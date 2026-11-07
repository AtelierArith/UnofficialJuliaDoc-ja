```julia
minimum(itr; [init])
```

コレクション内の最小の要素を返します。

空の`itr`に対して返す値は、`init`で指定できます。この値は`min`の中立元（つまり、ほかのどの要素以上でもある値）でなければなりません。空でないコレクションに対して`init`が使われるかどうかは指定されていないためです。

!!! compat "Julia 1.6"
    キーワード引数`init`を使用するには、Julia 1.6以降が必要です。


# Examples

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
