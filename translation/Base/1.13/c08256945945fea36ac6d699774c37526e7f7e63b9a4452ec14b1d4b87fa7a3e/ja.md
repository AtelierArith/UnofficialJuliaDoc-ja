```julia
merge(d::AbstractDict, others::AbstractDict...)
```

指定されたコレクションを結合して、新しいコレクションを作成します。必要に応じて、結合後のコレクションの型は、結合するコレクションの型に対応できるように昇格されます。同じキーが複数のコレクションに存在する場合、そのキーの値には、最後に指定されたコレクションの値が使われます。同じキーを持つ値をカスタム処理する方法については、[`mergewith`](@ref)も参照してください。

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

julia> merge(a, b)
Dict{String, Float64} with 3 entries:
  "bar" => 4711.0
  "baz" => 17.0
  "foo" => 0.0

julia> merge(b, a)
Dict{String, Float64} with 3 entries:
  "bar" => 42.0
  "baz" => 17.0
  "foo" => 0.0
```
