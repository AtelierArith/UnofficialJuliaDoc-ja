```julia
basename(path::AbstractString) -> String
```

パスのファイル名部分を取得します。

!!! note
    この関数はUnixの`basename`プログラムとはわずかに異なり、末尾のスラッシュは無視されます。つまり、`$ basename /foo/bar/`は`bar`を返しますが、Juliaの`basename`は空の文字列`""`を返します。


# 例

```jldoctest
julia> basename("/home/myuser/example.jl")
"example.jl"

julia> basename("/home/myuser/")
""
```

他に[`dirname`](@ref)を参照してください。
