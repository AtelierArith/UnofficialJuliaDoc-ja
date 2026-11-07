```julia
dlopen(f::Function, args...; kwargs...)
```

`do`ブロックと併用するラッパーです。制御フローが`do`ブロックのスコープを抜けると、動的ライブラリを自動的に閉じます。

# Examples

```julia
vendor = dlopen("libblas") do lib
    if Libdl.dlsym(lib, :openblas_set_num_threads; throw_error=false) !== nothing
        return :openblas
    else
        return :other
    end
end
```
