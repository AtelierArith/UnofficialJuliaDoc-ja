```
dlopen(f::Function, args...; kwargs...)
```

`do` ブロックでの使用のためのラッパーで、制御フローが `do` ブロックのスコープを離れると自動的に動的ライブラリを閉じます。

# 例

```julia
vendor = dlopen("libblas") do lib
    if Libdl.dlsym(lib, :openblas_set_num_threads; throw_error=false) !== nothing
        return :openblas
    else
        return :other
    end
end
```
