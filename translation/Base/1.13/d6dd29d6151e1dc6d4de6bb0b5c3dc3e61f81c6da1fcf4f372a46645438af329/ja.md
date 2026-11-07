```julia
code_typed(f, types; kw...)
```

指定されたジェネリック関数と型シグネチャに一致するメソッドについて、型推論済みの低レベル表現（IR）の配列を返します。

# Keyword Arguments

  * `optimize::Bool = true`: 省略可能です。インライン化などの追加の最適化も適用するかどうかを制御します。
  * `debuginfo::Symbol = :default`: 省略可能です。出力に含めるコードメタデータの量を制御します。指定できる値は `:source` または `:none` です。

# Internal Keyword Arguments

このセクションは内部向けであり、Juliaコンパイラの内部実装を理解している人のみを対象としています。

  * `world::UInt = Base.get_world_counter()`: 省略可能です。メソッドの検索に使用するワールドエイジを制御します。指定しない場合は、現在のワールドエイジが使用されます。
  * `interp::Core.Compiler.AbstractInterpreter = Core.Compiler.NativeInterpreter(world)`: 省略可能です。使用する抽象インタープリターを制御します。指定しない場合は、ネイティブインタープリターが使用されます。

# Examples

引数の型をタプルにまとめると、対応する `code_typed` を取得できます。

```julia
julia> code_typed(+, (Float64, Float64))
1-element Vector{Any}:
 CodeInfo(
1 ─ %1 = Base.add_float(x, y)::Float64
└──      return %1
) => Float64

julia> code_typed((typeof(-), Float64, Float64))
1-element Vector{Any}:
 CodeInfo(
1 ─ %1 = Base.sub_float(x, y)::Float64
└──      return %1
) => Float64

julia> code_typed((Type{Int}, UInt8))
1-element Vector{Any}:
 CodeInfo(
1 ─ %1 = Core.zext_int(Core.Int64, x)::Int64
└──      return %1
) => Int64

julia> code_typed((Returns{Int64},))
1-element Vector{Any}:
 CodeInfo(
1 ─ %1 =   builtin Base.getfield(obj, :value)::Int64
└──      return %1
) => Int64
```
