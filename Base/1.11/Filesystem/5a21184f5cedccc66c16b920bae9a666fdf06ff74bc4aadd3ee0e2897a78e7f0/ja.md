```
isfile(path) -> Bool
```

`path`が通常のファイルであれば`true`を返し、それ以外の場合は`false`を返します。

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

他にも[`isdir`](@ref)や[`ispath`](@ref)を参照してください。
