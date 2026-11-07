```julia
Time(f::Function, h, mi=0; step::Period=Second(1), limit::Int=10000)
Time(f::Function, h, mi, s; step::Period=Millisecond(1), limit::Int=10000)
Time(f::Function, h, mi, s, ms; step::Period=Microsecond(1), limit::Int=10000)
Time(f::Function, h, mi, s, ms, us; step::Period=Nanosecond(1), limit::Int=10000)
```

adjuster API を使って `Time` を作成します。開始点は、指定された `h, mi, s, ms, us` 引数から構築され、`f::Function` が `true` を返すまで調整されます。調整時のステップ幅は、`step` キーワードで手動指定できます。`limit` は、調整 API がエラーをスローするまでに実行する反復回数の上限を指定します（`f::Function` が一度も満たされない場合）。なお、デフォルトのステップ幅は、指定された引数に応じてより高い精度が得られるよう調整されます。たとえば、時、分、秒の引数が指定されている場合、デフォルトのステップ幅は `Second(1)` ではなく `Millisecond(1)` になります。

# Examples

```jldoctest
julia> Time(t -> minute(t) == 30, 20)
20:30:00

julia> Time(t -> minute(t) == 0, 20)
20:00:00

julia> Time(t -> hour(t) == 10, 3; limit = 5)
ERROR: ArgumentError: Adjustment limit reached: 5 iterations
Stacktrace:
[...]
```
