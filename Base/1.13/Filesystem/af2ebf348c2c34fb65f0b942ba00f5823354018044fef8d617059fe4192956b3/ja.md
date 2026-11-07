```julia
dirname(path::AbstractString)::String
```

パスのディレクトリ部分を取得します。パス末尾の文字（'/' または '\'）は、パスの一部として扱われます。

# Examples

```jldoctest
julia> dirname("/home/myuser")
"/home"

julia> dirname("/home/myuser/")
"/home/myuser"
```

[`basename`](@ref) も参照してください。
