```julia
startswith(s::AbstractString, prefix::Regex)
```

`s`が正規表現パターン`prefix`で始まる場合、`true`を返します。

!!! note
    `startswith`はアンカーを正規表現にコンパイルせず、代わりにアンカーを`match_option`としてPCREに渡します。コンパイル時間を償却できる場合、`occursin(r"^...", s)`のほうが`startswith(s, r"...")`より高速です。


関連項目：[`occursin`](@ref)、[`endswith`](@ref)、[`match`](@ref)

!!! compat "Julia 1.2"
    このメソッドを使用するには、Julia 1.2以降が必要です。


# Examples

```jldoctest
julia> startswith("JuliaLang", r"Julia|Romeo")
true
```
