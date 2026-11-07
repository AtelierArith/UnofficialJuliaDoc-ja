```julia
DateTime(dt::AbstractString, format::AbstractString; locale="english")
```

`format` 文字列で指定されたパターンに従って、`dt` 日時文字列を解析し、`DateTime` を構築します（構文については [`DateFormat`](@ref) を参照）。

!!! note
    このメソッドは、呼び出すたびに `DateFormat` オブジェクトを作成します。同じ書式を繰り返し使用する場合のパフォーマンス低下を避けるため、代わりに [`DateFormat`](@ref) オブジェクトを作成し、それを第2引数として使用することをおすすめします。


# Examples

```jldoctest
julia> DateTime("2020-01-01", "yyyy-mm-dd")
2020-01-01T00:00:00

julia> a = ("2020-01-01", "2020-01-02");

julia> [DateTime(d, dateformat"yyyy-mm-dd") for d ∈ a] # preferred
2-element Vector{DateTime}:
 2020-01-01T00:00:00
 2020-01-02T00:00:00
```
