```julia
tryparse(x::Union{AbstractString, IO})
tryparse(p::Parser, x::Union{AbstractString, IO})
```

文字列またはストリーム `x` を解析し、結果のテーブル（辞書）を返します。失敗した場合は [`ParserError`](@ref) を返します。

他にも [`TOML.parse`](@ref) を参照してください。
