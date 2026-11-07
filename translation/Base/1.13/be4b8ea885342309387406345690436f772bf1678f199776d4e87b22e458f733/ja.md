```julia
printstyled([io], xs...; bold::Bool=false, italic::Bool=false, underline::Bool=false, blink::Bool=false, reverse::Bool=false, hidden::Bool=false, color::Union{Symbol,Int}=:normal)
```

`xs`を、シンボルまたは整数で指定した色で出力します。太字にすることもできます。

キーワード`color`には、`:normal`、`:italic`、`:default`、`:bold`、`:black`、`:blink`、`:blue`、`:cyan`、`:green`、`:hidden`、`:light_black`、`:light_blue`、`:light_cyan`、`:light_green`、`:light_magenta`、`:light_red`、`:light_white`、`:light_yellow`、`:magenta`、`:nothing`、`:red`、`:reverse`、`:underline`、`:white`、`:yellow`、または0以上255以下の整数を指定できます。ただし、すべての端末が256色に対応しているわけではありません。

キーワード`bold=true`、`italic=true`、`underline=true`、`blink=true`の意味は明らかです。キーワード`reverse=true`を指定すると、前景色と背景色を入れ替えて出力します。`hidden=true`は端末上では見えませんが、コピーすることはできます。これらの属性は任意に組み合わせて使用できます。

関連項目：[`print`](@ref)、[`println`](@ref)、[`show`](@ref)。

!!! note
    すべての端末が斜体表示に対応しているわけではありません。斜体を反転表示または点滅表示として解釈する端末もあります。


!!! compat "Julia 1.7"
    `color`と`bold`を除くキーワードは、Julia 1.7で追加されました。


!!! compat "Julia 1.10"
    斜体表示への対応はJulia 1.10で追加されました。

