```
nworkers()
```

利用可能なワーカープロセスの数を取得します。これは[`nprocs()`](@ref)より1少ないです。`nprocs() == 1`の場合は`nprocs()`と等しくなります。

# 例

```julia-repl
$ julia -p 2

julia> nprocs()
3

julia> nworkers()
2
```
