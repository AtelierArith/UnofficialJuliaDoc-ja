```julia
parse(x::Union{AbstractString, IO})
parse(p::Parser, x::Union{AbstractString, IO})
```

文字列またはストリーム `x` を解析し、結果のテーブル（辞書）を返します。失敗した場合は [`ParserError`](@ref) をスローします。

また、[`TOML.tryparse`](@ref) も参照してください。
