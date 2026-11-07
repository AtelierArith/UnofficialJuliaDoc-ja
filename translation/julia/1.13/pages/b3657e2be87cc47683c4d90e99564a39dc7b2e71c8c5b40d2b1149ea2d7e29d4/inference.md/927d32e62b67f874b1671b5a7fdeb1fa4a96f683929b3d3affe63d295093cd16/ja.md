# Inference

## How inference works

Juliaコンパイラにおける「型推論」とは、入力値の型から後続の値の型を推定する処理を指します。Juliaの型推論の仕組みについては、以下のブログ記事で解説されています。

1. [Shows a simplified implementation of the data-flow analysis algorithm, that Julia's type inference routine is based on.](https://aviatesk.github.io/posts/data-flow-problem/)
2. [Gives a high level view of inference with a focus on its inter-procedural convergence guarantee.](https://info.juliahub.com/inference-convergence-algorithm-in-julia)
3. [Explains a refinement on the algorithm introduced in 2.](https://info.juliahub.com/inference-convergence-algorithm-in-julia-revisited)

## Debugging compiler.jl

Juliaセッションを起動し、`compiler/*.jl`を編集して（たとえば、`print`文を挿入して）、実行中のセッションで`Core.Compiler`を置き換えるには、`base`に移動して`include("compiler/compiler.jl")`を実行します。この方法を使えば、変更のたびにJuliaを再ビルドする場合と比べて、通常は開発を大幅に高速化できます。

別の方法として、Juliaセッションの開始時に`Revise.track(Core.Compiler)`コマンドを実行し、[Revise.jl](https://github.com/timholy/Revise.jl)パッケージを使ってコンパイラの変更を追跡できます。[Revise documentation](https://timholy.github.io/Revise.jl/stable/)で説明されているように、変更したファイルを保存すると、その変更がコンパイラに反映されます。

型推論を調べる際の便利な入口は`typeinf_code`です。`convert(Int, UInt(1))`に対して型推論を実行する例を示します。

```julia
# Get the method
atypes = Tuple{Type{Int}, UInt}  # argument types
mths = methods(convert, atypes)  # worth checking that there is only one
m = first(mths)

# Create variables needed to call `typeinf_code`
interp = Core.Compiler.NativeInterpreter()
sparams = Core.svec()      # this particular method doesn't have type-parameters
run_optimizer = true       # run all inference optimizations
types = Tuple{typeof(convert), atypes.parameters...} # Tuple{typeof(convert), Type{Int}, UInt}
Core.Compiler.typeinf_code(interp, m, types, sparams, run_optimizer)
```

デバッグ中に`MethodInstance`が必要になった場合は、上記の変数を使って`Core.Compiler.specialize_method`を呼び出すと確認できます。`CodeInfo`オブジェクトは、次のようにして取得できます。

```julia
# Returns the CodeInfo object for `convert(Int, ::UInt)`:
ci = (@code_typed convert(Int, UInt(1)))[1]
```

## The inlining algorithm (`inline_worthy`)

インライン化に関する最も難しい処理の多くは、`ssa_inlining_pass!`で行われます。ただし、「なぜ自分の関数はインライン化されなかったのか」という疑問がある場合は、関数呼び出しをインライン化するかどうかを判断する`inline_worthy`に注目するとよいでしょう。

`inline_worthy`はコストモデルを実装しており、「低コスト」な関数をインライン化します。より具体的には、インライン化しない場合に[issue a call](https://en.wikipedia.org/wiki/Calling_convention)する時間と比べて、予想実行時間が大きくない関数をインライン化します。このコストモデルは非常に単純で、多くの重要な詳細を無視しています。たとえば、すべての`for`ループは1回だけ実行されるものとして解析され、`if...else...end`のコストにはすべての分岐のコストの合計が含まれます。また、コストモデルが実際の実行コストをどれほど正確に予測できるかを検証するのに適した関数群が、現時点では用意されていないことにも留意してください。ただし、[BaseBenchmarks](https://github.com/JuliaCI/BaseBenchmarks.jl)からは、インライン化アルゴリズムの変更が成功したかどうかについて、多くの間接的な情報を得られます。

コストモデルの基盤となるのは、`add_tfunc`とその呼び出し元で実装されているルックアップテーブルです。このテーブルは、Juliaの各組み込み関数に推定コスト（CPUサイクル数）を割り当てます。これらのコストは[standard ranges for common architectures](http://ithare.com/wp-content/uploads/part101_infographics_v08.png)に基づいています（詳しくは[Agner Fog's analysis](https://www.agner.org/optimize/instruction_tables.pdf)を参照）。

この低レベルのルックアップテーブルに加えて、いくつかの特別なケースも設けています。たとえば、`:invoke`式（入力と出力の型がすべて事前に推論されている呼び出し）には、固定コスト（現在は20サイクル）が割り当てられます。一方、組み込み関数以外の関数に対する`:call`式は、その呼び出しに動的ディスパッチが必要であることを示します。この場合、`Params.inline_nonleaf_penalty`で定められたコスト（現在は`1000`）を割り当てます。これは動的ディスパッチの実際のコストを第一原理から見積もったものではなく、動的ディスパッチが非常に高コストであることを示す単なるヒューリスティックです。

各文の合計コストは、`statement_cost`という関数で解析されます。各文に割り当てられたコストは、次のように表示できます。

```jldoctest; filter=r"tuple.jl:\d+"
julia> Base.print_statement_costs(stdout, map, (typeof(sqrt), Tuple{Int},)) # map(sqrt, (2,))
map(f, t::Tuple{Any}) @ Base tuple.jl:358
  0 1 ─ %1  = $(Expr(:boundscheck, true))::Bool
  0 │   %2  =   builtin Base.getfield(_3, 1, %1)::Int64
  1 │   %3  = intrinsic Base.sitofp(Float64, %2)::Float64
  0 │   %4  = intrinsic Base.lt_float(%3, 0.0)::Bool
  0 └──       goto #3 if not %4
  0 2 ─          invoke Base.Math.throw_complex_domainerror(:sqrt::Symbol, %3::Float64)::Union{}
  0 └──       unreachable
 20 3 ─ %8  = intrinsic Base.Math.sqrt_llvm(%3)::Float64
  0 └──       goto #4
  0 4 ─       goto #5
  0 5 ─ %11 =   builtin Core.tuple(%8)::Tuple{Float64}
  0 └──       return %11

```

左側の列に各行のコストが表示されます。このコストには、インライン化やその他の最適化による影響も含まれます。
