```julia
endswith(s::AbstractString, suffix::Regex)
```

`s`が正規表現パターン`suffix`で終わる場合、`true`を返します。

!!! note
    `endswith`はアンカーを正規表現にコンパイルせず、代わりにアンカーを`match_option`としてPCREに渡します。コンパイル時間を償却できる場合、`occursin(r"...$", s)`は`endswith(s, r"...")`より高速です。


関連項目：[`occursin`](@ref)、[`startswith`](@ref)、[`match`](@ref)

!!! compat "Julia 1.2"
    このメソッドを使用するには、Julia 1.2以降が必要です。


# Examples

```jldoctest
julia> endswith("JuliaLang", r"Lang|Roberts")
true
```
