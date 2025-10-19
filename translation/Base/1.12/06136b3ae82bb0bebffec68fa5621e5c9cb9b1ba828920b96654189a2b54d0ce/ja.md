```julia
code_typed(f, types; kw...)
```

指定された汎用関数と型シグネチャに一致するメソッドの型推論された低レベル形式（IR）の配列を返します。

# キーワード引数

  * `optimize::Bool = true`: オプション、インライン化などの追加最適化が適用されるかどうかを制御します。
  * `debuginfo::Symbol = :default`: オプション、出力に含まれるコードメタデータの量を制御します。可能なオプションは `:source` または `:none` です。

# 内部キーワード引数

このセクションは内部的なものであり、Juliaコンパイラの内部を理解している人のためのものです。

  * `world::UInt = Base.get_world_counter()`: オプション、メソッドを検索する際に使用するワールドエイジを制御します。指定されていない場合は現在のワールドエイジを使用します。
  * `interp::Core.Compiler.AbstractInterpreter = Core.Compiler.NativeInterpreter(world)`: オプション、使用する抽象インタープリタを制御します。指定されていない場合はネイティブインタープリタを使用します。

# 例

引数の型をタプルに入れることで、対応する `code_typed` を取得できます。

```julia
julia> code_typed(+, (Float64, Float64))
1-element Vector{Any}:
 CodeInfo(
1 ─ %1 = Base.add_float(x, y)::Float64
└──      return %1
) => Float64
```
