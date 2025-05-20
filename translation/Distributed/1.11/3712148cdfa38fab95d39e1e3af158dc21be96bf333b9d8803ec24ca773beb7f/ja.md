```
procs()
```

プロセス識別子のリストを返します。pid 1（[`workers()`](@ref) には含まれない）を含みます。

# 例

```julia-repl
$ julia -p 2

julia> procs()
3-element Array{Int64,1}:
 1
 2
 3
```
