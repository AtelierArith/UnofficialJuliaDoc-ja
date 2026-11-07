```julia
Date(d::AbstractString, format::AbstractString; locale="english")
```

`d`の日付文字列を、`format`文字列で指定されたパターンに従って解析し、`Date`を構築します（構文については[`DateFormat`](@ref)を参照）。

!!! note
    このメソッドは、呼び出すたびに`DateFormat`オブジェクトを作成します。同じ書式を繰り返し使用する際のパフォーマンス低下を避けるため、代わりに[`DateFormat`](@ref)オブジェクトを作成し、それを第2引数として使用することをおすすめします。


# Examples

```jldoctest
julia> Date("2020-01-01", "yyyy-mm-dd")
2020-01-01

julia> a = ("2020-01-01", "2020-01-02");

julia> [Date(d, dateformat"yyyy-mm-dd") for d ∈ a] # preferred
2-element Vector{Date}:
 2020-01-01
 2020-01-02
```
