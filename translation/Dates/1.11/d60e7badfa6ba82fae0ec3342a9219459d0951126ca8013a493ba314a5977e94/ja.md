```julia
Dates
```

`Dates` モジュールは、`Date`、`DateTime`、`Time` 型と、それらに関連する関数を提供します。

これらの型はタイムゾーンを扱わず、UT 秒（1 日を 86400 秒とし、うるう秒は考慮しません）に基づいています。また、[ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) で規定されている先発グレゴリオ暦を使用します。タイムゾーン機能については、TimeZones.jl パッケージを参照してください。

```jldoctest
julia> dt = DateTime(2017,12,31,23,59,59,999)
2017-12-31T23:59:59.999

julia> d1 = Date(Month(12), Year(2017))
2017-12-01

julia> d2 = Date("2017-12-31", DateFormat("y-m-d"))
2017-12-31

julia> yearmonthday(d2)
(2017, 12, 31)

julia> d2-d1
30 days
```

詳しくは、マニュアルの [`Date`](@ref) および [`DateTime`](@ref) のセクションを参照してください。
