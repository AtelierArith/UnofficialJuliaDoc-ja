# Bounds checking

多くの現代的なプログラミング言語と同様に、Juliaは配列にアクセスする際のプログラムの安全性を確保するために境界チェックを使用します。厳密な内側のループやその他のパフォーマンスが重要な状況では、実行時のパフォーマンスを向上させるために、これらの境界チェックをスキップしたい場合があります。たとえば、ベクトル化された（SIMD）命令を発行するためには、ループ本体に分岐が含まれてはならず、したがって境界チェックも含まれてはなりません。その結果、Juliaは、指定されたブロック内でそのような境界チェックをスキップするようコンパイラに指示する`@inbounds(...)`マクロを含んでいます。ユーザー定義の配列型は、文脈に応じたコード選択を実現するために`@boundscheck(...)`マクロを使用できます。

## Eliding bounds checks

`@boundscheck(...)` マクロは、境界チェックを実行するコードのブロックにマークを付けます。このようなブロックが `@inbounds(...)` ブロックにインライン化されると、コンパイラはこれらのブロックを削除することがあります。コンパイラは、`@boundscheck` ブロックを *呼び出し関数にインライン化された場合のみ* 削除します。たとえば、メソッド `sum` を次のように記述することができます:

```julia
function sum(A::AbstractArray)
    r = zero(eltype(A))
    for i in eachindex(A)
        @inbounds r += A[i]
    end
    return r
end
```

カスタム配列のような型 `MyArray` を持つ:

```julia
@inline getindex(A::MyArray, i::Real) = (@boundscheck checkbounds(A, i); A.data[to_index(i)])
```

そのため、`getindex`が`sum`にインライン化されると、`checkbounds(A, i)`への呼び出しは省略されます。関数に複数のインライン化のレイヤーが含まれている場合、`@boundscheck`ブロックは、インライン化の深さが最大1レベルのものだけが削除されます。このルールは、スタックの上部にあるコードからの意図しないプログラムの動作の変更を防ぎます。

### Caution!

`@inbounds`を使うことで、安全でない操作を誤って露出させるのは簡単です。上記の例を次のように書きたくなるかもしれません。

```julia
function sum(A::AbstractArray)
    r = zero(eltype(A))
    for i in 1:length(A)
        @inbounds r += A[i]
    end
    return r
end
```

どのように静かに1ベースのインデックスを仮定し、したがって[`OffsetArrays`](@ref man-custom-indices)を使用すると不安全なメモリアクセスを露呈するか:

```julia-repl
julia> using OffsetArrays

julia> sum(OffsetArray([1, 2, 3], -10))
9164911648 # inconsistent results or segfault
```

元のエラーの原因は `1:length(A)` ですが、`@inbounds` の使用により、境界エラーの影響が、より簡単に捕捉できずデバッグも難しい不正なメモリアクセスにまで拡大します。`@inbounds` を使用するメソッドが安全であることを証明することはしばしば困難または不可能であるため、特に公開APIにおいては、セグメンテーションフォルトや静かな誤動作のリスクに対してパフォーマンス向上の利点を天秤にかける必要があります。

## Propagating inbounds

コードの整理の理由から、`@inbounds` と `@boundscheck` の宣言の間に複数のレイヤーを置きたい場合があるかもしれません。たとえば、デフォルトの `getindex` メソッドは、`getindex(A::AbstractArray, i::Real)` が `getindex(IndexStyle(A), A, i)` を呼び出し、さらにそれが `_getindex(::IndexLinear, A, i)` を呼び出します。

「一層のインライン化」ルールをオーバーライドするために、関数は [`Base.@propagate_inbounds`](@ref) でマークされ、追加のインライン化を通じてインバウンズコンテキスト（またはアウトオブバウンズコンテキスト）を伝播させることができます。

## The bounds checking call hierarchy

全体の階層は：

  * `checkbounds(A, I...)` は呼び出します

      * `checkbounds(Bool, A, I...)` は呼び出します

          * `checkbounds_indices(Bool, axes(A), I)` は再帰的に呼び出します

              * `checkindex` 各次元のために

ここで `A` は配列であり、`I` は「要求された」インデックスを含んでいます。 `axes(A)` は `A` の「許可された」インデックスのタプルを返します。

`checkbounds(A, I...)` はインデックスが無効な場合にエラーをスローしますが、`checkbounds(Bool, A, I...)` はその場合に `false` を返します。 `checkbounds_indices` は配列に関する情報を `axes` タプル以外は破棄し、純粋なインデックス対インデックスの比較を行います：これにより、比較的少数のコンパイルされたメソッドが多様な配列タイプに対応できるようになります。 インデックスはタプルとして指定され、通常は1対1の方法で比較され、個々の次元は別の重要な関数 `checkindex` を呼び出すことで処理されます：通常、

```julia
checkbounds_indices(Bool, (IA1, IA...), (I1, I...)) = checkindex(Bool, IA1, I1) &
                                                      checkbounds_indices(Bool, IA, I)
```

`checkindex` は単一の次元をチェックします。これらの関数はすべて、エクスポートされていない `checkbounds_indices` を含め、`?` を使ってアクセス可能なドキュメント文字列を持っています。

特定の配列タイプの境界チェックをカスタマイズする必要がある場合は、`checkbounds(Bool, A, I...)`を特化させるべきです。しかし、ほとんどの場合、配列タイプに対して有用な`axes`を提供する限り、`checkbounds_indices`に依存できるはずです。

新しいインデックス型がある場合は、まず特定の次元の配列に対して単一のインデックスを処理する `checkindex` を特化することを検討してください。カスタムの多次元インデックス型（`CartesianIndex` に似たもの）がある場合は、`checkbounds_indices` を特化することを検討する必要があるかもしれません。

この階層は、メソッドの曖昧さの可能性を減らすために設計されています。私たちは `checkbounds` を配列型に特化させる場所にし、インデックス型に対する特化は避けるようにしています。逆に、`checkindex` はインデックス型（特に最後の引数）にのみ特化されることを意図しています。

## Emit bounds checks

Juliaは`--check-bounds={yes|no|auto}`を使用して起動することができ、常に境界チェックを行う、決して行わない、または`@inbounds`宣言を尊重します。
