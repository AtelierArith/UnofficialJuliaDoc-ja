```julia
SubstitutionString(substr) <: AbstractString
```

正規表現による置換で使用するため、指定された文字列 `substr` を `SubstitutionString` として格納します。通常は [`@s_str`](@ref) マクロを使って構築します。

# Examples

```jldoctest
julia> SubstitutionString("Hello \\g<name>, it's \\1")
s"Hello \g<name>, it's \1"

julia> subst = s"Hello \g<name>, it's \1"
s"Hello \g<name>, it's \1"

julia> typeof(subst)
SubstitutionString{String}
```
