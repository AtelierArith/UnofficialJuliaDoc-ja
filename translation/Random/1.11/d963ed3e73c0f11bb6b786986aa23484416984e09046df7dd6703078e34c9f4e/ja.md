```julia
bitrand([rng=default_rng()], [dims...])
```

ランダムな真偽値からなる`BitArray`を生成します。

# Examples

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
