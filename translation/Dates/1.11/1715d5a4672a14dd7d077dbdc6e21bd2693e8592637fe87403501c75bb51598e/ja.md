```
Date(d::AbstractString, format::AbstractString; locale="english") -> Date
```

`format` 文字列に従って `d` 日付文字列を解析することによって `Date` を構築します（構文については [`DateFormat`](@ref) を参照してください）。

!!! note
    このメソッドは呼び出されるたびに `DateFormat` オブジェクトを作成します。同じフォーマットを繰り返し使用する際のパフォーマンス低下を避けるために、代わりに [`DateFormat`](@ref) オブジェクトを作成し、それを第二引数として使用することをお勧めします。


# 例

```jldoctest
julia> Date("2020-01-01", "yyyy-mm-dd")
2020-01-01

julia> a = ("2020-01-01", "2020-01-02");

julia> [Date(d, dateformat"yyyy-mm-dd") for d ∈ a] # preferred
2-element Vector{Date}:
 2020-01-01
 2020-01-02
```
