```julia
LogLevel(level)
```

ログレコードの重大度/冗長性。

ログレベルは、潜在的なログレコードがフィルタリングされる基準を提供します。これは、ログレコードデータ構造自体を構築するための他の作業が行われる前に行われます。

# 例

```julia-repl
julia> Logging.LogLevel(0) == Logging.Info
true
```
