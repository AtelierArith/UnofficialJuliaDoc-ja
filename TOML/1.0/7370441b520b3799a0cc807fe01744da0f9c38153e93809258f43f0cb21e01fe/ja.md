```julia
tryparsefile(f::AbstractString)
tryparsefile(p::Parser, f::AbstractString)
```

ファイル `f` を解析し、結果のテーブル（辞書）を返します。失敗した場合は [`ParserError`](@ref) を返します。

関連情報として [`TOML.parsefile`](@ref) も参照してください。
