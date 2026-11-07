```julia
DateTime
```

`DateTime`は、先発グレゴリオ暦における時点を表します。時間の最小単位はミリ秒です（つまり、この型ではマイクロ秒やナノ秒を表現できません）。この型は固定小数点演算をサポートするため、アンダーフローやオーバーフローが発生しやすくなっています。その顕著な例として、`Microsecond`または`Nanosecond`を加算したときの丸めがあります。

```jldoctest
julia> dt = DateTime(2023, 8, 19, 17, 45, 32, 900)
2023-08-19T17:45:32.900

julia> dt + Millisecond(1)
2023-08-19T17:45:32.901

julia> dt + Microsecond(1000) # 1000us == 1ms
2023-08-19T17:45:32.901

julia> dt + Microsecond(999) # 999us rounded to 1000us
2023-08-19T17:45:32.901

julia> dt + Microsecond(1499) # 1499 rounded to 1000us
2023-08-19T17:45:32.901
```
