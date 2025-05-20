```
readeach(io::IO, T)
```

[`read(io, T)`](@ref) を返す反復可能なオブジェクトを生成します。

他にも [`skipchars`](@ref)、[`eachline`](@ref)、[`readuntil`](@ref) を参照してください。

!!! compat "Julia 1.6"
    `readeach` は Julia 1.6 以降が必要です。


# 例

```jldoctest
julia> io = IOBuffer("JuliaLang is a GitHub organization.\n It has many members.\n");

julia> for c in readeach(io, Char)
           c == '\n' && break
           print(c)
       end
JuliaLang is a GitHub organization.
```
