```julia
DateTime(f::Function, y[, m, d, h, mi, s]; step=Day(1), limit=10000) -> DateTime
```

調整者APIを通じて`DateTime`を作成します。出発点は提供された`y, m, d...`引数から構築され、`f::Function`が`true`を返すまで調整されます。調整のステップサイズは`step`キーワードを通じて手動で提供できます。`limit`は、`f::Function`が満たされない場合にエラーをスローする前に調整APIが追求する最大反復回数の制限を提供します。

# 例

```jldoctest
julia> DateTime(dt -> second(dt) == 40, 2010, 10, 20, 10; step = Second(1))
2010-10-20T10:00:40

julia> DateTime(dt -> hour(dt) == 20, 2010, 10, 20, 10; step = Hour(1), limit = 5)
ERROR: ArgumentError: Adjustment limit reached: 5 iterations
Stacktrace:
[...]
```
