```julia
@fetchfrom
```

`fetch(@spawnat p expr)` と同等です。 [`fetch`](@ref) と [`@spawnat`](@ref) を参照してください。

# 例

```julia-repl
julia> addprocs(3);

julia> @fetchfrom 2 myid()
2

julia> @fetchfrom 4 myid()
4
```
