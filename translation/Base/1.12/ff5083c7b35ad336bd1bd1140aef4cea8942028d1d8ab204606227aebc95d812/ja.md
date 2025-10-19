```julia
inv(x)
```

`x`の乗法逆数を返します。すなわち、`x*inv(x)`または`inv(x)*x`は、丸め誤差を考慮して[`one(x)`](@ref)（乗法単位元）を返します。

`x`が数値である場合、これは本質的に`one(x)/x`と同じですが、いくつかの型に対しては`inv(x)`の方がわずかに効率的である場合があります。

# 例

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
    `inv(::Missing)`は少なくともJulia 1.2が必要です。

