```julia
endswith(s::AbstractString, suffix::Regex)
```

`s`が正規表現パターン`suffix`で終わる場合は`true`を返します。

!!! note
    `endswith`はアンカリングを正規表現にコンパイルせず、代わりにアンカリングを`match_option`としてPCREに渡します。コンパイル時間が償却される場合、`occursin(r"...$", s)`は`endswith(s, r"...")`よりも速くなります。


他に[`occursin`](@ref)や[`startswith`](@ref)も参照してください。

!!! compat "Julia 1.2"
    このメソッドは少なくともJulia 1.2が必要です。


# 例

```jldoctest
julia> endswith("JuliaLang", r"Lang|Roberts")
true
```
