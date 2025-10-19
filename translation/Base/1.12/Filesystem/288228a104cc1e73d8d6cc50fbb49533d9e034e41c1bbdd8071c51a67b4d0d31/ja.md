```julia
isdir(path) -> Bool
isdir(path_elements...) -> Bool
```

`path`がディレクトリを指している場合は`true`を返し、それ以外の場合は`false`を返します。

# 例

```jldoctest
julia> isdir(homedir())
true

julia> isdir("not/a/directory")
false
```

他に[`isfile`](@ref)や[`ispath`](@ref)も参照してください。
