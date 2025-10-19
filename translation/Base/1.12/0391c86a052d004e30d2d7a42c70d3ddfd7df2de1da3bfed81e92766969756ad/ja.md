```julia
open(f::Function, args...; kwargs...)
```

関数 `f` を `open(args...; kwargs...)` の結果に適用し、完了後に生成されたファイルディスクリプタを閉じます。

# 例

```jldoctest
julia> write("myfile.txt", "Hello world!");

julia> open(io->read(io, String), "myfile.txt")
"Hello world!"

julia> rm("myfile.txt")
```
