```
tryparse(x::Union{AbstractString, IO})
tryparse(p::Parser, x::Union{AbstractString, IO})
```

文字列またはストリーム `x` を解析し、結果のテーブル（辞書）を返します。失敗した場合は [`ParserError`](@ref) を返します。

関連情報として [`TOML.parse`](@ref) も参照してください。
