```julia
escape_string(str::AbstractString[, esc]; keep=(), ascii=false, fullhex=false)::AbstractString
escape_string(io, str::AbstractString[, esc]; keep=())::Nothing
```

従来のC形式およびUnicode形式のエスケープシーケンスを一般的にエスケープします。1つ目の形式はエスケープ後の文字列を返し、2つ目の形式は結果を`io`に出力します。

バックスラッシュ（`\`）は、二重のバックスラッシュ（`"\\"`）にエスケープされます。印字できない文字は、標準的なC形式のエスケープコード、NULの場合は`"\0"`（曖昧さがない場合）、Unicodeコードポイント（`"\u"`プレフィックス）、または16進数（`"\x"`プレフィックス）でエスケープされます。

省略可能な`esc`引数では、先頭にバックスラッシュを付けてエスケープする追加の文字を指定します（1つ目の形式では、`"`もデフォルトでエスケープされます）。

`keep`引数では、そのまま保持する文字の集合を指定します。ただし、ここでは`esc`が優先されます。

`ascii`引数を`true`に設定すると、ASCII以外のすべての文字がエスケープされます。デフォルトの`ascii=false`では、印字可能なUnicode文字はそのまま出力されます。（`keep`は`ascii`より優先されます。）

`fullhex`引数を`true`に設定すると、すべての`\u`エスケープは4桁の16進数で、`\U`エスケープは8桁の16進数で出力されます。デフォルト（`fullhex=false`）では、可能な場合は先頭のゼロを省略し、桁数を少なくして出力します。

逆の操作については、[`unescape_string`](@ref)も参照してください。

!!! compat "Julia 1.7"
    `keep`引数はJulia 1.7以降で使用できます。


!!! compat "Julia 1.12"
    `ascii`引数と`fullhex`引数にはJulia 1.12が必要です。


# Examples

```jldoctest
julia> escape_string("aaa\nbbb")
"aaa\\nbbb"

julia> escape_string("aaa\nbbb"; keep = '\n')
"aaa\nbbb"

julia> escape_string("\xfe\xff") # invalid utf-8
"\\xfe\\xff"

julia> escape_string(string('\u2135','\0')) # unambiguous
"ℵ\\0"

julia> escape_string(string('\u2135','\0','0')) # \0 would be ambiguous
"ℵ\\x000"
```
