# Inference

## How inference works

Juliaコンパイラにおける「型推論」とは、入力値の型から後の値の型を推測するプロセスを指します。Juliaの推論に対するアプローチは、以下のブログ記事で説明されています：

1. [Shows a simplified implementation of the data-flow analysis algorithm, that Julia's type inference routine is based on.](https://aviatesk.github.io/posts/data-flow-problem/)
2. [Gives a high level view of inference with a focus on its inter-procedural convergence guarantee.](https://info.juliahub.com/inference-convergence-algorithm-in-julia)
3. [Explains a refinement on the algorithm introduced in 2.](https://info.juliahub.com/inference-convergence-algorithm-in-julia-revisited)

## Debugging compiler.jl

Juliaセッションを開始し、`compiler/*.jl`を編集（例えば`print`ステートメントを挿入するために）し、その後、実行中のセッションで`Core.Compiler`を置き換えるには、`base`に移動して`include("compiler/compiler.jl")`を実行します。このトリックは、各変更のためにJuliaを再構築するよりも、通常ははるかに速い開発につながります。

代わりに、[Revise.jl](https://github.com/timholy/Revise.jl) パッケージを使用して、Julia セッションの最初に `Revise.track(Core.Compiler)` コマンドを実行することでコンパイラの変更を追跡できます。[Revise documentation](https://timholy.github.io/Revise.jl/stable/) で説明されているように、コンパイラへの変更は、修正されたファイルが保存されると反映されます。

推論への便利な入り口は `typeinf_code` です。以下は `convert(Int, UInt(1))` に対して推論を実行するデモです：

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

デバッグの冒険で `MethodInstance` が必要な場合は、上記の多くの変数を使用して `Core.Compiler.specialize_method` を呼び出すことで検索できます。`CodeInfo` オブジェクトは次のように取得できます。

```julia
# Returns the CodeInfo object for `convert(Int, ::UInt)`:
ci = (@code_typed convert(Int, UInt(1)))[1]
```

## The inlining algorithm (`inline_worthy`)

インライン化のための最も難しい作業の多くは `ssa_inlining_pass!` で実行されます。しかし、「なぜ私の関数はインライン化されなかったのか？」という質問がある場合、あなたはおそらく `inline_worthy` に興味があるでしょう。これは関数呼び出しをインライン化するかどうかの決定を行います。

`inline_worthy` implements a cost-model, where "cheap" functions get inlined; more specifically, we inline functions if their anticipated run-time is not large compared to the time it would take to [issue a call](https://en.wikipedia.org/wiki/Calling_convention) to them if they were not inlined. The cost-model is extremely simple and ignores many important details: for example, all `for` loops are analyzed as if they will be executed once, and the cost of an `if...else...end` includes the summed cost of all branches. It's also worth acknowledging that we currently lack a suite of functions suitable for testing how well the cost model predicts the actual run-time cost, although [BaseBenchmarks](https://github.com/JuliaCI/BaseBenchmarks.jl) provides a great deal of indirect information about the successes and failures of any modification to the inlining algorithm.

コストモデルの基盤は、`add_tfunc` とその呼び出し元で実装されたルックアップテーブルであり、Juliaの各組み込み関数に対して推定コスト（CPUサイクルで測定）を割り当てます。これらのコストは [standard ranges for common architectures](http://ithare.com/wp-content/uploads/part101_infographics_v08.png) に基づいています（詳細については [Agner Fog's analysis](https://www.agner.org/optimize/instruction_tables.pdf) を参照してください）。

この低レベルのルックアップテーブルには、いくつかの特別なケースが補足されています。たとえば、すべての入力および出力タイプが事前に推論された呼び出しである `:invoke` 式には、固定コスト（現在は20サイクル）が割り当てられます。対照的に、intrinsics/builtins以外の関数に対する `:call` 式は、呼び出しが動的ディスパッチを必要とすることを示しており、その場合、`Params.inline_nonleaf_penalty` によって設定されたコスト（現在は `1000` に設定されています）が割り当てられます。これは、動的ディスパッチの生のコストの「第一原理」に基づく推定ではなく、動的ディスパッチが非常に高価であることを示す単なるヒューリスティックであることに注意してください。

各ステートメントは、`statement_cost`という関数でその総コストが分析されます。各ステートメントに関連するコストを次のように表示できます：

```jldoctest; filter=r"tuple.jl:\d+"
julia> Base.print_statement_costs(stdout, map, (typeof(sqrt), Tuple{Int},)) # map(sqrt, (2,))
map(f, t::Tuple{Any}) @ Base tuple.jl:281
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

行のコストは左の列にあります。これにはインライン化やその他の最適化の影響が含まれています。
