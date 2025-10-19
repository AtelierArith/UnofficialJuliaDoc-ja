```julia
isfile(path) -> Bool
isfile(path_elements...) -> Bool
```

`path` が通常のファイルを指している場合は `true` を返し、それ以外の場合は `false` を返します。

# 例

```jldoctest
julia> isfile(homedir())
false

julia> filename = "test_file.txt";

julia> write(filename, "Hello world!");

julia> isfile(filename)
true

julia> rm(filename);

julia> isfile(filename)
false
```

他に [`isdir`](@ref) と [`ispath`](@ref) も参照してください。
