```julia
extrema(itr; [init]) -> (mn, mx)
```

最小の`mn`要素と最大の`mx`要素を1回の走査で計算し、2タプルとして返します。

空の`itr`に対して返す値は、`init`で指定できます。これは、1番目と2番目の要素がそれぞれ`min`と`max`の中立元（つまり、ほかのどの要素よりも大きいか等しい値、および小さいか等しい値）である2タプルでなければなりません。そのため、`itr`が空の場合、返される`(mn, mx)`タプルは`mn ≥ mx`を満たします。`init`を指定した場合は、空でない`itr`に対しても使用できます。

!!! compat "Julia 1.8"
    キーワード引数`init`を使用するには、Julia 1.8以降が必要です。


# Examples

```jldoctest
julia> extrema(2:10)
(2, 10)

julia> extrema([9,pi,4.5])
(3.141592653589793, 9.0)

julia> extrema([]; init = (Inf, -Inf))
(Inf, -Inf)
```
