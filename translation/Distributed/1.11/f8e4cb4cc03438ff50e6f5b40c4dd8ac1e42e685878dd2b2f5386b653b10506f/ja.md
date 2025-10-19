```julia
myid()
```

現在のプロセスのIDを取得します。

# 例

```julia-repl
julia> myid()
1

julia> remotecall_fetch(() -> myid(), 4)
4
```
