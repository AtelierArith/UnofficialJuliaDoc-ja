```julia
myid()
```

現在のプロセスの ID を取得します。

# Examples

```julia-repl
julia> myid()
1

julia> remotecall_fetch(() -> myid(), 4)
4
```
