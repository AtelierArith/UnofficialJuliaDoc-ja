```julia
workers()
```

すべてのワーカープロセスの識別子を返します。

# Examples

```julia-repl
$ julia -p 2

julia> workers()
2-element Array{Int64,1}:
 2
 3
```
