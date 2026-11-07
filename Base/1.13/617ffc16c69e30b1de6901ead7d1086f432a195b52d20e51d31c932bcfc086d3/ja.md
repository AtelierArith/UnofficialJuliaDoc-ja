```julia
mergewith(combine, d::AbstractDict, others::AbstractDict...)
mergewith(combine)
```

指定されたコレクションから、結合したコレクションを構築します。必要に応じて、結合後のコレクションの型は、結合するコレクションの型に対応できるように昇格されます。同じキーを持つ値は、結合関数を使ってまとめられます。カリー化形式の `mergewith(combine)` は、関数 `(args...) -> mergewith(combine, args...)` を返します。

!!! compat "Julia 1.5"
    `mergewith` には Julia 1.5 以降が必要です。


# Examples

```jldoctest; filter = r"^\s+\S+\s+=>\s+\S+$"m
julia> a = Dict("foo" => 0.0, "bar" => 42.0)
Dict{String, Float64} with 2 entries:
  "bar" => 42.0
  "foo" => 0.0

julia> b = Dict("baz" => 17, "bar" => 4711)
Dict{String, Int64} with 2 entries:
  "bar" => 4711
  "baz" => 17

julia> mergewith(+, a, b)
Dict{String, Float64} with 3 entries:
  "bar" => 4753.0
  "baz" => 17.0
  "foo" => 0.0

julia> ans == mergewith(+)(a, b)
true

julia> mergewith(-, Dict(), Dict(:a=>1))  # Combining function only used if key is present in both
Dict{Any, Any} with 1 entry:
  :a => 1
```
