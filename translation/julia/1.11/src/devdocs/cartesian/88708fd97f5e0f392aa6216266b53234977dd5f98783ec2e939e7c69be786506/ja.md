# Base.Cartesian

非エクスポートのCartesianモジュールは、多次元アルゴリズムを書くためのマクロを提供します。ほとんどの場合、[straightforward techniques](https://julialang.org/blog/2016/02/iteration)を使ってそのようなアルゴリズムを書くことができますが、`Base.Cartesian`が依然として便利または必要な場合がいくつかあります。

## Principles of usage

使用の簡単な例は次のとおりです：

```julia
@nloops 3 i A begin
    s += @nref 3 A i
end
```

次のコードを生成します：

```julia
for i_3 = axes(A, 3)
    for i_2 = axes(A, 2)
        for i_1 = axes(A, 1)
            s += A[i_1, i_2, i_3]
        end
    end
end
```

一般的に、Cartesianは、ネストされたループのような繰り返し要素を含む汎用コードを書くことを可能にします。他の用途には、繰り返しの式（例：ループの展開）や、「スプラット」構文（`i...`）を使用せずに可変数の引数を持つ関数呼び出しを作成することが含まれます。

## Basic syntax

`@nloops`の（基本的な）構文は次のとおりです：

  * 最初の引数は整数でなければならず（*変数ではなく*）、ループの回数を指定します。
  * 2番目の引数は、イテレータ変数に使用されるシンボルプレフィックスです。ここでは `i` を使用し、変数 `i_1, i_2, i_3` が生成されました。
  * 第三の引数は、各イテレータ変数の範囲を指定します。ここで変数（シンボル）を使用すると、それは `axes(A, dim)` として扱われます。より柔軟に、以下に説明する無名関数式の構文を使用することができます。
  * ループの最後の引数は、ループの本体です。ここでは、それが `begin...end` の間に表示されます。

`@nloops`の追加機能については、[reference section](@ref dev-cartesian-reference)に記載されています。

`@nref`は似たようなパターンに従い、`@nref 3 A i`から`A[i_1,i_2,i_3]`を生成します。一般的な慣習は左から右に読むことであり、そのため`@nloops`は`@nloops 3 i A expr`です（`for i_2 = axes(A, 2)`のように、`i_2`は左側にあり、範囲は右側にあります）に対し、`@nref`は`@nref 3 A i`です（`A[i_1,i_2,i_3]`のように、配列が最初に来ます）。

Cartesianでコードを開発している場合、生成されたコードを調べることでデバッグが容易になることがあります。その際は`@macroexpand`を使用してください：

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

これらのマクロの最初の引数は式の数であり、整数でなければなりません。複数の次元で機能することを意図した関数を書くとき、これはハードコーディングしたくないものかもしれません。推奨されるアプローチは、`@generated function`を使用することです。以下はその例です：

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

もちろん、`quote`ブロックの前に式を準備したり計算を行ったりすることもできます。

### Anonymous-function expressions as macro arguments

おそらく `Cartesian` の最も強力な機能の一つは、解析時に評価される無名関数式を提供できることです。簡単な例を考えてみましょう：

```julia
@nexprs 2 j->(i_j = 1)
```

`@nexprs`は、パターンに従った`n`の式を生成します。このコードは次のステートメントを生成します：

```julia
i_1 = 1
i_2 = 1
```

各生成されたステートメントでは、匿名関数の変数である「孤立した」`j`が範囲`1:2`の値に置き換えられます。一般的に言えば、CartesianはLaTeXのような構文を使用しています。これにより、インデックス`j`に対して数学的な操作を行うことができます。以下は、配列のストライドを計算する例です：

```julia
s_1 = 1
@nexprs 3 j->(s_{j+1} = s_j * size(A, j))
```

表現を生成します

```julia
s_1 = 1
s_2 = s_1 * size(A, 1)
s_3 = s_2 * size(A, 2)
s_4 = s_3 * size(A, 3)
```

匿名関数式は実際に多くの用途があります。

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
