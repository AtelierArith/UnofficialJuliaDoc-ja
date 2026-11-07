```julia
dirname(path::AbstractString)::String
```

パスのディレクトリ部分を取得します。パスの末尾にある文字（'/' または '\'）もパスの一部として扱われます。

# Examples

```jldoctest
julia> dirname("/home/myuser")
"/home"

julia> dirname("/home/myuser/")
"/home/myuser"
```

[`basename`](@ref) も参照してください。
