```julia
Date(f::Function, y[, m, d]; step=Day(1), limit=10000)::Date
```

adjuster API を通じて `Date` を作成します。開始点は、指定された `y, m, d` 引数から構築され、`f::Function` が `true` を返すまで調整されます。調整時のステップサイズは、`step` キーワードで手動指定できます。`limit` は、`f::Function` が満たされない場合に、エラーをスローするまで調整 API が実行する最大反復回数を制限します。

# Examples

```jldoctest
julia> Date(date -> week(date) == 20, 2010, 01, 01)
2010-05-17

julia> Date(date -> year(date) == 2010, 2000, 01, 01)
2010-01-01

julia> Date(date -> month(date) == 10, 2000, 01, 01; limit = 5)
ERROR: ArgumentError: Adjustment limit reached: 5 iterations
Stacktrace:
[...]
```
