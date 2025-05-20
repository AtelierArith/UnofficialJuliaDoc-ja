```
DateTime
```

`DateTime`は、先行グレゴリオ暦に従った時点を表します。時間の最も細かい解像度はミリ秒です（すなわち、マイクロ秒やナノ秒はこの型では表現できません）。この型は固定小数点演算をサポートしているため、アンダーフロー（およびオーバーフロー）を起こす可能性があります。注目すべき結果は、`Microsecond`や`Nanosecond`を加算する際の丸めです：

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
