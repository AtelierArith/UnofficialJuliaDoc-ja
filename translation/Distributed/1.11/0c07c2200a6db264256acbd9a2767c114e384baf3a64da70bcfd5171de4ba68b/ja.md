```julia
nworkers()
```

利用可能なワーカープロセス数を取得します。これは [`nprocs()`](@ref) より 1 つ少ない数です。`nprocs() == 1` の場合は `nprocs()` と等しくなります。

# Examples

```julia-repl
$ julia -p 2

julia> nprocs()
3

julia> nworkers()
2
```
