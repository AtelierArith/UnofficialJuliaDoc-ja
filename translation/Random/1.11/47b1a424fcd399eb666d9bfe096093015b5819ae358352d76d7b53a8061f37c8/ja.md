```julia
bitrand([rng=default_rng()], [dims...])
```

ランダムなブール値の `BitArray` を生成します。

# 例

```jldoctest
julia> bitrand(Xoshiro(123), 10)
10-element BitVector:
 0
 1
 0
 1
 0
 1
 0
 0
 1
 1
```
