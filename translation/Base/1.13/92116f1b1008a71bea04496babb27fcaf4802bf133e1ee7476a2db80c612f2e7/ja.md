```julia
vect(X...)
```

引数の`promote_typeof`から要素型を計算し、引数リストを格納する[`Vector`](@ref)を作成します。

# Examples

```jldoctest
julia> a = Base.vect(UInt8(1), 2.5, 1//2)
3-element Vector{Float64}:
 1.0
 2.5
 0.5
```
