```julia
axpby!(a, X, b, Y)
```

`Y` を `X*a + Y*b` で上書きします。`a` と `b` はスカラーです。`Y` を返します。

# Examples

```jldoctest
julia> x = [1., 2, 3];

julia> y = [4., 5, 6];

julia> BLAS.axpby!(2., x, 3., y)
3-element Vector{Float64}:
 14.0
 19.0
 24.0
```
