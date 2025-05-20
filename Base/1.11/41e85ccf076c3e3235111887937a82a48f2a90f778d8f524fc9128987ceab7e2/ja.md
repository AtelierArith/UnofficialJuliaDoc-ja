```
merge(d::AbstractDict, others::AbstractDict...)
```

与えられたコレクションからマージされたコレクションを構築します。必要に応じて、結果のコレクションの型はマージされたコレクションの型に合わせて昇格されます。同じキーが別のコレクションに存在する場合、そのキーの値は最後にリストされたコレクションにある値になります。同じキーを持つ値のカスタム処理については、[`mergewith`](@ref)を参照してください。

# 例

```jldoctest
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
