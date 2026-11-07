```julia
inv(x)
```

`x` の乗法逆元を返します。`x*inv(x)` または `inv(x)*x` を計算すると、丸め誤差の範囲内で [`one(x)`](@ref)（乗法単位元）になります。

`x` が数値の場合、これは基本的に `one(x)/x` と同じですが、型によっては `inv(x)` のほうがわずかに効率的な場合があります。

# Examples

```jldoctest
julia> inv(2)
0.5

julia> inv(1 + 2im)
0.2 - 0.4im

julia> inv(1 + 2im) * (1 + 2im)
1.0 + 0.0im

julia> inv(2//3)
3//2
```

!!! compat "Julia 1.2"
    `inv(::Missing)` を使用するには、Julia 1.2 以降が必要です。

