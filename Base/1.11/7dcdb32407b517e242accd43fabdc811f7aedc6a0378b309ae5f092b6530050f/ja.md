```
escape_string(str::AbstractString[, esc]; keep = ())::AbstractString
escape_string(io, str::AbstractString[, esc]; keep = ())::Nothing
```

従来のCおよびUnicodeエスケープシーケンスの一般的なエスケープ。最初の形式はエスケープされた文字列を返し、2番目は結果を`io`に出力します。

バックスラッシュ（`\`）はダブルバックスラッシュ（`"\\"`）でエスケープされます。非表示文字は、標準のCエスケープコード（NULの場合は`"\0"`、あいまいでない場合）、Unicodeコードポイント（`"\u"`プレフィックス）または16進数（`"\x"`プレフィックス）でエスケープされます。

オプションの`esc`引数は、バックスラッシュを前に付けてエスケープされるべき追加の文字を指定します（最初の形式では`"`もデフォルトでエスケープされます）。

引数`keep`は、そのまま保持されるべき文字のコレクションを指定します。ここでは`esc`が優先されることに注意してください。

逆操作については、[`unescape_string`](@ref)も参照してください。

!!! compat "Julia 1.7"
    `keep`引数はJulia 1.7以降で利用可能です。


# 例

```jldoctest
julia> escape_string("aaa\nbbb")
"aaa\\nbbb"

julia> escape_string("aaa\nbbb"; keep = '\n')
"aaa\nbbb"

julia> escape_string("\xfe\xff") # 無効なutf-8
"\\xfe\\xff"

julia> escape_string(string('\u2135','\0')) # あいまいでない
"ℵ\\0"

julia> escape_string(string('\u2135','\0','0')) # \0はあいまいになる
"ℵ\\x000"
```
