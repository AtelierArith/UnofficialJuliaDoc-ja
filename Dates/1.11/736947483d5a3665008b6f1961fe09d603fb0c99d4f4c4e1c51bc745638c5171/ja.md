```julia
Time(t::AbstractString, format::AbstractString; locale="english")
```

`Time`を、`format`文字列で指定されたパターンに従って`t`時刻文字列を解析することで構築します（構文については[`DateFormat`](@ref)を参照）。

!!! note
    このメソッドは呼び出すたびに`DateFormat`オブジェクトを作成します。同じ書式を繰り返し使用する際のパフォーマンス低下を避けるため、代わりに[`DateFormat`](@ref)オブジェクトを作成し、それを第2引数として使用することをおすすめします。


# Examples

```jldoctest
julia> Time("12:34pm", "HH:MMp")
12:34:00

julia> a = ("12:34pm", "2:34am");

julia> [Time(d, dateformat"HH:MMp") for d ∈ a] # preferred
2-element Vector{Time}:
 12:34:00
 02:34:00
```
