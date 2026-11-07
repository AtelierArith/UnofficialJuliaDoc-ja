```julia
reverse(v [, start=firstindex(v) [, stop=lastindex(v) ]] )
```

`v`を先頭から末尾まで逆順にしたコピーを返します。コピーを作成せずに逆順で反復処理する方法については[`Iterators.reverse`](@ref)を、インプレースで行う方法については[`reverse!`](@ref)も参照してください。

# Examples

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
