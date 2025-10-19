```julia
reverse(v [, start=firstindex(v) [, stop=lastindex(v) ]] )
```

`v`のコピーを、startからstopまで逆順に返します。コピーを作成せずに逆順で反復するには、[`Iterators.reverse`](@ref)を参照してください。また、インプレースでの[`reverse!`](@ref)もあります。

# 例

```jldoctest
julia> A = Vector(1:5)
5-element Vector{Int64}:
 1
 2
 3
 4
 5

julia> reverse(A)
5-element Vector{Int64}:
 5
 4
 3
 2
 1

julia> reverse(A, 1, 4)
5-element Vector{Int64}:
 4
 3
 2
 1
 5

julia> reverse(A, 3, 5)
5-element Vector{Int64}:
 1
 2
 5
 4
 3
```
