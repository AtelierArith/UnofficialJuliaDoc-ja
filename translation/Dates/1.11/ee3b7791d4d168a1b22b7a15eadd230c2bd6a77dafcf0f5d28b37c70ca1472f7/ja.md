```julia
Time(t::AbstractString, format::AbstractString; locale="english") -> Time
```

`t` 時間文字列を `format` 文字列で指定されたパターンに従って解析することで `Time` を構築します（構文については [`DateFormat`](@ref) を参照してください）。

!!! note
    このメソッドは呼び出されるたびに `DateFormat` オブジェクトを作成します。同じフォーマットを繰り返し使用する際のパフォーマンス低下を避けるために、代わりに [`DateFormat`](@ref) オブジェクトを作成し、それを第二引数として使用することをお勧めします。


# 例

```jldoctest
julia> Time("12:34pm", "HH:MMp")
12:34:00

julia> a = ("12:34pm", "2:34am");

julia> [Time(d, dateformat"HH:MMp") for d ∈ a] # preferred
2-element Vector{Time}:
 12:34:00
 02:34:00
```
