```julia
mergewith(combine, d::AbstractDict, others::AbstractDict...)
mergewith(combine)
merge(combine, d::AbstractDict, others::AbstractDict...)
```

与えられたコレクションからマージされたコレクションを構築します。必要に応じて、結果のコレクションの型はマージされたコレクションの型に合わせて昇格されます。同じキーを持つ値は、コンバイナ関数を使用して結合されます。カリー化された形式 `mergewith(combine)` は、関数 `(args...) -> mergewith(combine, args...)` を返します。

メソッド `merge(combine::Union{Function,Type}, args...)` は、後方互換性のために `mergewith(combine, args...)` のエイリアスとしてまだ利用可能です。

!!! compat "Julia 1.5"
    `mergewith` は Julia 1.5 以降が必要です。


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

julia> mergewith(+, a, b)
Dict{String, Float64} with 3 entries:
  "bar" => 4753.0
  "baz" => 17.0
  "foo" => 0.0

julia> ans == mergewith(+)(a, b)
true

julia> mergewith(-, Dict(), Dict(:a=>1))  # キーが両方に存在する場合のみ結合関数が使用される
Dict{Any, Any} with 1 entry:
  :a => 1
```
