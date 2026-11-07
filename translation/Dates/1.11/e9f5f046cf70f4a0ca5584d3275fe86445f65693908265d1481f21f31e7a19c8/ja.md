```julia
DateTime(f::Function, y[, m, d, h, mi, s]; step=Day(1), limit=10000)::DateTime
```

adjuster API を通じて `DateTime` を作成します。開始点は、指定された `y, m, d...` 引数から構築され、`f::Function` が `true` を返すまで調整されます。調整時のステップサイズは、`step` キーワードで手動指定できます。`limit` は、調整 API がエラーをスローするまでに実行する反復回数の上限を指定します（`f::Function` が満たされない場合）。

# Examples

```jldoctest
julia> DateTime(dt -> second(dt) == 40, 2010, 10, 20, 10; step = Second(1))
2010-10-20T10:00:40

julia> DateTime(dt -> hour(dt) == 20, 2010, 10, 20, 10; step = Hour(1), limit = 5)
ERROR: ArgumentError: Adjustment limit reached: 5 iterations
Stacktrace:
[...]
```
