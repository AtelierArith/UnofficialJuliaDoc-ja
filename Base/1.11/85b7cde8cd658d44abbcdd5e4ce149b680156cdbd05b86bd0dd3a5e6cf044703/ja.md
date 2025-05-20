```
SubstitutionString(substr) <: AbstractString
```

与えられた文字列 `substr` を `SubstitutionString` として保存し、正規表現の置換に使用します。最も一般的には [`@s_str`](@ref) マクロを使用して構築されます。

# 例

```jldoctest
julia> SubstitutionString("Hello \\g<name>, it's \\1")
s"Hello \g<name>, it's \1"

julia> subst = s"Hello \g<name>, it's \1"
s"Hello \g<name>, it's \1"

julia> typeof(subst)
SubstitutionString{String}
```
