```julia
open(f::Function, args...; kwargs...)
```

`open(args...; kwargs...)`の結果に関数`f`を適用し、完了後に生成されたファイル記述子を閉じてください。

# Examples

```jldoctest
julia> write("myfile.txt", "Hello world!");

julia> open(io->read(io, String), "myfile.txt")
"Hello world!"

julia> rm("myfile.txt")
```
