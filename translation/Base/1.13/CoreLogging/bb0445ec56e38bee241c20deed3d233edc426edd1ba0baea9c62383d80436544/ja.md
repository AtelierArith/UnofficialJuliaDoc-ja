```julia
LogLevel(level)
```

ログレコードの重大度／詳細度。

ログレベルは、ログレコードのデータ構造を構築するための処理を始める前に、ログレコード候補をフィルタリングするための基準となります。

# Examples

```jldoctest; setup = :(import Logging)
julia> Logging.LogLevel(0) == Logging.Info
true
```
