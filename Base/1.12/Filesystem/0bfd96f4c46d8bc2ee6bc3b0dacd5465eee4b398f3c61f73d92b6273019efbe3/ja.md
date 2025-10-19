```julia
normpath(path::AbstractString) -> String
```

パスを正規化し、"."および".."のエントリを削除し、"/"をシステムの標準パス区切り文字に変更します。

# 例

```jldoctest
julia> normpath("/home/myuser/../example.jl")
"/home/example.jl"

julia> normpath("Documents/Julia") == joinpath("Documents", "Julia")
true
```
