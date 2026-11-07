```julia
parsefile(f::AbstractString)
parsefile(p::Parser, f::AbstractString)
```

`f` ファイルを解析し、結果のテーブル（辞書）を返します。失敗した場合は [`ParserError`](@ref) をスローします。

[`TOML.tryparsefile`](@ref) も参照してください。
