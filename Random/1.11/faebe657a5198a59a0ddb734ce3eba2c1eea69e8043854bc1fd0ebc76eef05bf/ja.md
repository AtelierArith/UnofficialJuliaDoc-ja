```julia
shuffle!([rng=default_rng(),] v::AbstractArray)
```

[`shuffle`](@ref)のインプレース版です。`v`をランダムに並べ替えます。必要に応じて、乱数生成器`rng`を指定できます。

# Examples

```jldoctest
julia> shuffle!(Xoshiro(0), Vector(1:6))
6-element Vector{Int64}:
 5
 1
 2
 6
 3
 4
```
