```julia
@inferred [AllowedType] f(x)
```

呼び出し式 `f(x)` が、コンパイラーの推論した型と同じ型の値を返すかどうかをテストします。型安定性の確認に役立ちます。

`f(x)` には任意の呼び出し式を指定できます。型が一致する場合は `f(x)` の結果を返し、異なる型が見つかった場合は `Error` `Result` を返します。

省略可能な `AllowedType` を指定すると、テストの条件が緩和されます。`f(x)` の型が `AllowedType` を法として推論型と一致する場合、または戻り値の型が `AllowedType` のサブタイプである場合に、テストが成功します。これは、`Union{Nothing, T}` や `Union{Missing, T}` のような小さなユニオン型を返す関数の型安定性をテストする際に便利です。

```jldoctest; setup = :(using InteractiveUtils; using Base: >), filter = r"begin\n(.|\n)*end"
julia> f(a) = a > 1 ? 1 : 1.0
f (generic function with 1 method)

julia> typeof(f(2))
Int64

julia> @code_warntype f(2)
MethodInstance for f(::Int64)
  from f(a) @ Main none:1
Arguments
  #self#::Core.Const(f)
  a::Int64
Body::UNION{FLOAT64, INT64}
1 ─ %1 = :>::Core.Const(>)
│   %2 = (%1)(a, 1)::Bool
└──      goto #3 if not %2
2 ─      return 1
3 ─      return 1.0

julia> @inferred f(2)
ERROR: return type Int64 does not match inferred return type Union{Float64, Int64}
[...]

julia> @inferred max(1, 2)
2

julia> g(a) = a < 10 ? missing : 1.0
g (generic function with 1 method)

julia> @inferred g(20)
ERROR: return type Float64 does not match inferred return type Union{Missing, Float64}
[...]

julia> @inferred Missing g(20)
1.0

julia> h(a) = a < 10 ? missing : f(a)
h (generic function with 1 method)

julia> @inferred Missing h(20)
ERROR: return type Int64 does not match inferred return type Union{Missing, Float64, Int64}
[...]
```
