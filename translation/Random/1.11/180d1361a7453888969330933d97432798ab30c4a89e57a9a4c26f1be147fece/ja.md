```julia
randsubseq!([rng=default_rng(),] S, A, p)
```

[`randsubseq`](@ref)と同様ですが、結果は必要に応じてサイズが変更される`S`に格納されます。

# Examples

```jldoctest
julia> S = Int64[];

julia> randsubseq!(Xoshiro(123), S, 1:8, 0.3)
2-element Vector{Int64}:
 4
 7

julia> S
2-element Vector{Int64}:
 4
 7
```
