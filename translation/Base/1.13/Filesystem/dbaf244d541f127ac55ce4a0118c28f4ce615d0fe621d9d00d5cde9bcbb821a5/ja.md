```julia
isabspath(path::AbstractString)::Bool
```

パスが絶対パス（ルートディレクトリから始まるパス）かどうかを判定します。

# Examples

```jldoctest
julia> isabspath("/home")
true

julia> isabspath("home")
false
```
