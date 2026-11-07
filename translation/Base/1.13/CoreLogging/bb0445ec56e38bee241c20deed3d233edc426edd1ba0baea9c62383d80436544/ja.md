```julia
LogLevel(level)
```

ログレコードの重大度／詳細度。

ログレベルを基準に、ログレコードのデータ構造を構築するための処理を始める前に、記録候補をフィルタリングできます。

# Examples

```jldoctest; setup = :(import Logging)
julia> Logging.LogLevel(0) == Logging.Info
true
```
