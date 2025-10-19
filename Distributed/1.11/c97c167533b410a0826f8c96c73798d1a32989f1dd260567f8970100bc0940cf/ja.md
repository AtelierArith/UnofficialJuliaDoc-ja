```julia
@fetch expr
```

`fetch(@spawnat :any expr)` と同等です。[`fetch`](@ref) と [`@spawnat`](@ref) を参照してください。

# 例

```julia-repl
julia> addprocs(3);

julia> @fetch myid()
2

julia> @fetch myid()
3

julia> @fetch myid()
4

julia> @fetch myid()
2
```
