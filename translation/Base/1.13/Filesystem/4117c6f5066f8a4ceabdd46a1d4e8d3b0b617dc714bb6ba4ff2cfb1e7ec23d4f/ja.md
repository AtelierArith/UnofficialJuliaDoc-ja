```julia
basename(path::AbstractString)::String
```

パスからファイル名部分を取得します。

!!! note
    この関数の動作は Unix の `basename` プログラムとは少し異なります。Unix では末尾のスラッシュが無視されるため、`$ basename /foo/bar/` は `bar` を返します。一方、Julia の `basename` は空文字列 `""` を返します。


# Examples

```jldoctest
julia> basename("/home/myuser/example.jl")
"example.jl"

julia> basename("/home/myuser/")
""
```

[`dirname`](@ref).
