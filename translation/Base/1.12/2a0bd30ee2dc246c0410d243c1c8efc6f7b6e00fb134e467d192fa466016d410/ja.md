```julia
printstyled([io], xs...; bold::Bool=false, italic::Bool=false, underline::Bool=false, blink::Bool=false, reverse::Bool=false, hidden::Bool=false, color::Union{Symbol,Int}=:normal)
```

`xs`をシンボルまたは整数で指定された色で印刷し、オプションで太字にします。

キーワード`color`は、`:normal`、`:italic`、`:default`、`:bold`、`:black`、`:blink`、`:blue`、`:cyan`、`:green`、`:hidden`、`:light_black`、`:light_blue`、`:light_cyan`、`:light_green`、`:light_magenta`、`:light_red`、`:light_white`、`:light_yellow`、`:magenta`、`:nothing`、`:red`、`:reverse`、`:underline`、`:white`、または`：yellow`、または0から255の間の整数を取ることができます。すべての端末が256色をサポートしているわけではないことに注意してください。

キーワード`bold=true`、`italic=true`、`underline=true`、`blink=true`は自己説明的です。キーワード`reverse=true`は前景と背景の色を交換して印刷し、`hidden=true`は端末では見えなくなりますが、コピーすることはできます。これらのプロパティは任意の組み合わせで使用できます。

他にも[`print`](@ref)、[`println`](@ref)、[`show`](@ref)を参照してください。

!!! note
    すべての端末がイタリック出力をサポートしているわけではありません。一部の端末はイタリックをリバースまたはブリンクとして解釈します。


!!! compat "Julia 1.7"
    `color`と`bold`を除くキーワードはJulia 1.7で追加されました。


!!! compat "Julia 1.10"
    イタリック出力のサポートはJulia 1.10で追加されました。

