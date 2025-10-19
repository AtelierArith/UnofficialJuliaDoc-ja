```julia
startswith(s::AbstractString, prefix::Regex)
```

`prefix`という正規表現パターンで`s`が始まる場合、`true`を返します。

!!! note
    `startswith`はアンカーを正規表現にコンパイルせず、代わりにアンカーを`match_option`としてPCREに渡します。コンパイル時間が分散される場合、`occursin(r"^...", s)`は`startswith(s, r"...")`よりも速くなります。


他に[`occursin`](@ref)や[`endswith`](@ref)を参照してください。

!!! compat "Julia 1.2"
    このメソッドは少なくともJulia 1.2が必要です。


# 例

```jldoctest
julia> startswith("JuliaLang", r"Julia|Romeo")
true
```
