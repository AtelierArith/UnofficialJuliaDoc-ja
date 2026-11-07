```julia
unescape_string(str::AbstractString, keep = ())::AbstractString
unescape_string(io, s::AbstractString, keep = ())::Nothing
```

従来の C および Unicode のエスケープシーケンスを一般的にアンエスケープします。最初の形式はエスケープを解除した文字列を返し、2 番目の形式は結果を `io` に出力します。引数 `keep` には、バックスラッシュとともにそのまま保持する文字の集合を指定します。

次のエスケープシーケンスを認識します。

  * エスケープされたバックスラッシュ（`\\`）
  * エスケープされた二重引用符（`\"`）
  * 標準的な C のエスケープシーケンス（`\a`、`\b`、`\t`、`\n`、`\v`、`\f`、`\r`、`\e`）
  * Unicode BMP コードポイント（`\u` の後に 1～4 桁の 16 進数を指定）
  * すべての Unicode コードポイント（`\U` の後に 1～8 桁の 16 進数を指定。最大値 = 0010ffff）
  * 16 進バイト（`\x` の後に 1～2 桁の 16 進数を指定）
  * 8 進バイト（`\` の後に 1～3 桁の 8 進数を指定）

[`escape_string`](@ref) も参照してください。

# Examples

```jldoctest
julia> unescape_string("aaa\\nbbb") # C escape sequence
"aaa\nbbb"

julia> unescape_string("\\u03c0") # unicode
"π"

julia> unescape_string("\\101") # octal
"A"

julia> unescape_string("aaa \\g \\n", ['g']) # using `keep` argument
"aaa \\g \n"
```
