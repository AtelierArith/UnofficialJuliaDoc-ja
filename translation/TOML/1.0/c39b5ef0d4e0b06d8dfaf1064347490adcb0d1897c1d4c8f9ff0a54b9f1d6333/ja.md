```julia
tryparsefile(f::AbstractString)
tryparsefile(p::Parser, f::AbstractString)
```

`f` ファイルを解析し、結果のテーブル（辞書）を返します。失敗した場合は [`ParserError`](@ref) を返します。

[`TOML.parsefile`](@ref) も参照してください。
