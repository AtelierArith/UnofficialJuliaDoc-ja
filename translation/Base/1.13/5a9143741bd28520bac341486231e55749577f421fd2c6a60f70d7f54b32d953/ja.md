```julia
code_ircode(f, [types])
```

推論に成功した場合は、`IRCode`と推論された戻り値の型のペアを配列で返します。推論に失敗した場合は、`IRCode`の代わりに`Method`が含まれます。

関連項目: [`code_typed`](@ref)

# Internal Keyword Arguments

このセクションは内部向けであり、Juliaコンパイラの内部実装を理解している人のみを対象としています。

  * `world::UInt = Base.get_world_counter()`: 省略可能。メソッドの検索に使用するワールドエイジを指定します。指定しない場合は、現在のワールドエイジが使用されます。
  * `interp::Core.Compiler.AbstractInterpreter = Core.Compiler.NativeInterpreter(world)`: 省略可能。使用する抽象インタープリターを指定します。指定しない場合は、ネイティブインタープリターが使用されます。
  * `optimize_until::Union{Int,String,Nothing} = nothing`: 省略可能。実行する最適化パスを指定します。文字列の場合は、オプティマイザーをどのパスまで実行するかを指定します。整数の場合は、実行するパスの数を指定します。`nothing`（デフォルト）の場合は、すべてのパスが実行されます。

# Examples

引数の型をタプルにまとめると、対応する`code_ircode`を取得できます。

```julia
julia> Base.code_ircode(+, (Float64, Int64))
1-element Vector{Any}:
 388 1 ─ %1 = Base.sitofp(Float64, _3)::Float64
    │   %2 = Base.add_float(_2, %1)::Float64
    └──      return %2
     => Float64

julia> Base.code_ircode(+, (Float64, Int64); optimize_until = "compact 1")
1-element Vector{Any}:
 388 1 ─ %1 = Base.promote(_2, _3)::Tuple{Float64, Float64}
    │   %2 = Core._apply_iterate(Base.iterate, Base.:+, %1)::Float64
    └──      return %2
     => Float64
```
