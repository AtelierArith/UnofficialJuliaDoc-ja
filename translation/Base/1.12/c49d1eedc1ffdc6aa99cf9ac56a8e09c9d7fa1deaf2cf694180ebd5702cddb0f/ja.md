```julia
extrema(itr; [init]) -> (mn, mx)
```

単一のパスで最小値 `mn` と最大値 `mx` の両方の要素を計算し、それらを2タプルとして返します。

空の `itr` に対して返される値は `init` によって指定できます。これは、最初の要素と第二の要素がそれぞれ `min` と `max` の中立要素である2タプルでなければなりません（すなわち、他のどの要素よりも大きい/小さいか等しい）。その結果、`itr` が空の場合、返される `(mn, mx)` タプルは `mn ≥ mx` を満たします。`init` が指定されている場合、非空の `itr` に対しても使用できます。

!!! compat "Julia 1.8"
    キーワード引数 `init` は Julia 1.8 以降が必要です。


# 例

```jldoctest
julia> extrema(2:10)
(2, 10)

julia> extrema([9,pi,4.5])
(3.141592653589793, 9.0)

julia> extrema([]; init = (Inf, -Inf))
(Inf, -Inf)
```
