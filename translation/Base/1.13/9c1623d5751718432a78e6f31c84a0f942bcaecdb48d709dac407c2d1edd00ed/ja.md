```julia
BitVector(nt::Tuple{Vararg{Bool}})
```

タプルから `BitVector` を構築します。`Bool`

# Examples

```jldoctest
julia> nt = (true, false, true, false)
(true, false, true, false)

julia> BitVector(nt)
4-element BitVector:
 1
 0
 1
 0
```
