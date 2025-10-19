```julia
DateTime(dt::AbstractString, format::AbstractString; locale="english") -> DateTime
```

`dt` 日付時刻文字列を `format` 文字列で指定されたパターンに従って解析することで `DateTime` を構築します（構文については [`DateFormat`](@ref) を参照してください）。

!!! note
    このメソッドは呼び出されるたびに `DateFormat` オブジェクトを作成します。同じフォーマットを繰り返し使用する際のパフォーマンス低下を避けるために、代わりに [`DateFormat`](@ref) オブジェクトを作成し、それを第二引数として使用することをお勧めします。


# 例

```jldoctest
julia> DateTime("2020-01-01", "yyyy-mm-dd")
2020-01-01T00:00:00

julia> a = ("2020-01-01", "2020-01-02");

julia> [DateTime(d, dateformat"yyyy-mm-dd") for d ∈ a] # preferred
2-element Vector{DateTime}:
 2020-01-01T00:00:00
 2020-01-02T00:00:00
```
