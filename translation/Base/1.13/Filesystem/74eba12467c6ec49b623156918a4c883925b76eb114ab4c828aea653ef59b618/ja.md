```julia
normpath(path::AbstractString)::String
```

パスを正規化します。「.」と「..」の要素を取り除き、「/」をシステムの標準パス区切り文字に置き換えます。

# Examples

```jldoctest
julia> normpath("/home/myuser/../example.jl")
"/home/example.jl"

julia> normpath("Documents/Julia") == joinpath("Documents", "Julia")
true
```
