# Base.Cartesian

（エクスポートされていない）Cartesian モジュールには、多次元アルゴリズムの記述を容易にするマクロが用意されています。多くの場合、このようなアルゴリズムは [straightforward techniques](https://julialang.org/blog/2016/02/iteration) を使って記述できますが、`Base.Cartesian` が依然として役立つ、あるいは必要となるケースもいくつかあります。

## Principles of usage

使用例を簡単に示します。

```julia
@nloops 3 i A begin
    s += @nref 3 A i
end
```

これは次のコードを生成します。

```julia
for i_3 = axes(A, 3)
    for i_2 = axes(A, 2)
        for i_1 = axes(A, 1)
            s += A[i_1, i_2, i_3]
        end
    end
end
```

一般に、Cartesian を使うと、この例の入れ子になったループのように、繰り返し要素を含む汎用コードを記述できます。ほかにも、式の繰り返し（ループ展開など）や、「スプラット」構文（`i...`）を使わずに可変個の引数を取る関数呼び出しを作成するといった用途があります。

## Basic syntax

`@nloops` の基本的な構文は次のとおりです。

  * 第1引数には、ループ数を指定する整数（変数では*ありません*）を指定します。
  * 第2引数には、イテレーター変数に付けるシンボルの接頭辞を指定します。ここでは `i` を使い、`i_1, i_2, i_3` という変数が生成されます。
  * 第3引数には、各イテレーター変数の範囲を指定します。ここに変数（シンボル）を指定すると、`axes(A, dim)` として扱われます。より柔軟な方法として、後述する無名関数式の構文も使えます。
  * 最後の引数には、ループ本体を指定します。ここでは、`begin...end` の間に記述されている部分が該当します。

`@nloops` には、[reference section](@ref dev-cartesian-reference) で説明する追加機能もあります。

`@nref` も同様のパターンに従い、`@nref 3 A i` から `A[i_1,i_2,i_3]` を生成します。基本的には左から右へ読みます。そのため、`@nloops` は `@nloops 3 i A expr` です（`for i_2 = axes(A, 2)` では、`i_2` が左側にあり、範囲が右側にあります）。一方、`@nref` は `@nref 3 A i` です（`A[i_1,i_2,i_3]` では、配列が先に来るためです）。

Cartesian を使ってコードを開発している場合、生成されたコードを `@macroexpand` で確認すると、デバッグが容易になることがあります。

```@meta
DocTestSetup = quote
    import Base.Cartesian: @nref
end
```

```jldoctest
julia> @macroexpand @nref 2 A i
:(A[i_1, i_2])
```

```@meta
DocTestSetup = nothing
```

### Supplying the number of expressions

これら2つのマクロの第1引数には、式の数を指定します。これは整数でなければなりません。複数の次元で動作する関数を作成する場合、この値をハードコードしたくないこともあるでしょう。推奨される方法は、`@generated function` を使うことです。例を示します。

```julia
@generated function mysum(A::Array{T,N}) where {T,N}
    quote
        s = zero(T)
        @nloops $N i A begin
            s += @nref $N A i
        end
        s
    end
end
```

もちろん、`quote` ブロックの前に、式を用意したり計算を行ったりすることもできます。

### Anonymous-function expressions as macro arguments

`Cartesian` の最も強力な機能のひとつは、パース時に評価される無名関数式を指定できることです。簡単な例を見てみましょう。

```julia
@nexprs 2 j->(i_j = 1)
```

`@nexprs` は、一定のパターンに従う `n` 式を生成します。このコードは、次の文を生成します。

```julia
i_1 = 1
i_2 = 1
```

生成される各文では、「独立した」`j`（無名関数の変数）が、範囲 `1:2` 内の値に置き換えられます。一般に、Cartesian では LaTeX に似た構文を使います。これにより、インデックス `j` に対する計算が可能になります。配列のストライドを計算する例を示します。

```julia
s_1 = 1
@nexprs 3 j->(s_{j+1} = s_j * size(A, j))
```

これにより、次の式が生成されます。

```julia
s_1 = 1
s_2 = s_1 * size(A, 1)
s_3 = s_2 * size(A, 2)
s_4 = s_3 * size(A, 3)
```

無名関数式は、実際にさまざまな用途で使えます。

#### [Macro reference](@id dev-cartesian-reference)

```@docs
Base.Cartesian.@nloops
Base.Cartesian.@nref
Base.Cartesian.@nextract
Base.Cartesian.@nexprs
Base.Cartesian.@ncall
Base.Cartesian.@ncallkw
Base.Cartesian.@ntuple
Base.Cartesian.@nall
Base.Cartesian.@nany
Base.Cartesian.@nif
```
