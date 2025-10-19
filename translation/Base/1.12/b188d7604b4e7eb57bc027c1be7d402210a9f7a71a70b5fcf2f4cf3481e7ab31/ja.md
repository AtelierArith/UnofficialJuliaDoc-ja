```julia
unescape_string(str::AbstractString, keep = ())::AbstractString
unescape_string(io, s::AbstractString, keep = ())::Nothing
```

従来のCおよびUnicodeエスケープシーケンスの一般的なアンエスケープ。最初の形式はエスケープされた文字列を返し、2番目は結果を`io`に出力します。引数`keep`は、（バックスラッシュとともに）そのまま保持される文字のコレクションを指定します。

次のエスケープシーケンスが認識されます：

  * エスケープされたバックスラッシュ (`\\`)
  * エスケープされたダブルクォート (`\"`)
  * 標準Cエスケープシーケンス (`\a`, `\b`, `\t`, `\n`, `\v`, `\f`, `\r`, `\e`)
  * Unicode BMPコードポイント (`\u`に1-4の後続の16進数)
  * すべてのUnicodeコードポイント (`\U`に1-8の後続の16進数; 最大値 = 0010ffff)
  * 16進バイト (`\x`に1-2の後続の16進数)
  * 8進バイト (`\`に1-3の後続の8進数)

詳細は[`escape_string`](@ref)を参照してください。

# 例

```jldoctest
julia> unescape_string("aaa\\nbbb") # Cエスケープシーケンス
"aaa\nbbb"

julia> unescape_string("\\u03c0") # unicode
"π"

julia> unescape_string("\\101") # 8進数
"A"

julia> unescape_string("aaa \\g \\n", ['g']) # `keep`引数を使用
"aaa \\g \n"
```
