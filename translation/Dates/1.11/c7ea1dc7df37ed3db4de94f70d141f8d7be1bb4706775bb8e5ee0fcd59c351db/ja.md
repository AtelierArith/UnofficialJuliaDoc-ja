```julia
Date(f::Function, y[, m, d]; step=Day(1), limit=10000) -> Date
```

調整者APIを通じて`Date`を作成します。出発点は提供された`y, m, d`引数から構築され、`f::Function`が`true`を返すまで調整されます。調整のステップサイズは`step`キーワードを通じて手動で提供できます。`limit`は、`f::Function`が決して満たされない場合に、調整APIがエラーを投げる前に追求する最大反復回数の制限を提供します。

# 例

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
