# Bounds checking

多くの現代プログラミング言語と同様に、Juliaは配列にアクセスする際のプログラムの安全性を確保するために境界チェックを使用します。厳密な内側のループやその他のパフォーマンスが重要な状況では、実行時のパフォーマンスを向上させるためにこれらの境界チェックをスキップしたい場合があります。たとえば、ベクトル化された（SIMD）命令を発行するためには、ループ本体に分岐が含まれていない必要があり、したがって境界チェックを含むことはできません。その結果、Juliaは指定されたブロック内でそのような境界チェックをスキップするようコンパイラに指示する`@inbounds(...)`マクロを含んでいます。ユーザー定義の配列型は、文脈に応じたコード選択を実現するために`@boundscheck(...)`マクロを使用できます。

## Eliding bounds checks

`@boundscheck(...)` マクロは、境界チェックを行うコードのブロックにマークを付けます。このようなブロックが `@inbounds(...)` ブロックにインライン化されると、コンパイラはこれらのブロックを削除することがあります。コンパイラは、`@boundscheck` ブロックを *呼び出し関数にインライン化された場合のみ* 削除します。たとえば、メソッド `sum` を次のように記述することができます:

```julia
function sum(A::AbstractArray)
    r = zero(eltype(A))
    for i in eachindex(A)
        @inbounds r += A[i]
    end
    return r
end
```

カスタム配列のような型 `MyArray` があり:

```julia
@inline getindex(A::MyArray, i::Real) = (@boundscheck checkbounds(A, i); A.data[to_index(i)])
```

その後、`getindex`が`sum`にインライン化されると、`checkbounds(A, i)`への呼び出しは省略されます。関数に複数のインライン化の層が含まれている場合、`@boundscheck`ブロックは、インライン化の深さが最大1レベルのものだけが削除されます。このルールは、スタックの上部にあるコードからの意図しないプログラムの動作の変更を防ぎます。

### Caution!

`@inbounds`を使うと、安全でない操作を誤って露出させるのは簡単です。上記の例を次のように書きたくなるかもしれません。

```julia
function sum(A::AbstractArray)
    r = zero(eltype(A))
    for i in 1:length(A)
        @inbounds r += A[i]
    end
    return r
end
```

どのようにして1ベースのインデックスを静かに仮定し、[`OffsetArrays`](@ref man-custom-indices)を使用すると不安全なメモリアクセスが露呈するのか:

```julia-repl
julia> using OffsetArrays

julia> sum(OffsetArray([1, 2, 3], -10))
9164911648 # inconsistent results or segfault
```

元のエラーの原因は `1:length(A)` ですが、`@inbounds` の使用により、境界エラーの影響が、より簡単には捕捉できずデバッグも難しい不正なメモリアクセスにまで拡大します。`@inbounds` を使用するメソッドが安全であることを証明することはしばしば困難または不可能であるため、特に公開されているAPIにおいては、セグメンテーションフォルトや静かな誤動作のリスクに対してパフォーマンスの向上の利点を天秤にかける必要があります。

## Propagating inbounds

コードの整理の理由から、`@inbounds` と `@boundscheck` の宣言の間に複数のレイヤーを置きたい場合があるかもしれません。たとえば、デフォルトの `getindex` メソッドは、`getindex(A::AbstractArray, i::Real)` が `getindex(IndexStyle(A), A, i)` を呼び出し、さらにそれが `_getindex(::IndexLinear, A, i)` を呼び出します。

「一層のインライン化」ルールをオーバーライドするために、関数は [`Base.@propagate_inbounds`](@ref) でマークされ、インバウンズコンテキスト（またはアウトオブバウンズコンテキスト）を追加のインライン化の一層を通じて伝播させることができます。

## The bounds checking call hierarchy

全体の階層は：

  * `checkbounds(A, I...)` は呼び出します

      * `checkbounds(Bool, A, I...)` は呼び出します

          * `checkbounds_indices(Bool, axes(A), I)` は再帰的に呼び出します。

              * `checkindex` 各次元のために

ここで `A` は配列であり、`I` は「要求された」インデックスを含んでいます。`axes(A)` は `A` の「許可された」インデックスのタプルを返します。

`checkbounds(A, I...)` はインデックスが無効な場合にエラーをスローしますが、`checkbounds(Bool, A, I...)` はその場合に `false` を返します。 `checkbounds_indices` は配列に関する情報を `axes` タプル以外は破棄し、純粋なインデックス対インデックスの比較を行います。これにより、比較的少数のコンパイル済みメソッドが多様な配列タイプに対応できるようになります。インデックスはタプルとして指定され、通常は1対1の方式で比較され、個々の次元は別の重要な関数 `checkindex` を呼び出すことで処理されます。通常、

```julia
checkbounds_indices(Bool, (IA1, IA...), (I1, I...)) = checkindex(Bool, IA1, I1) &
                                                      checkbounds_indices(Bool, IA, I)
```

`checkindex`は単一の次元をチェックします。これらのすべての関数、未エクスポートの`checkbounds_indices`を含め、`?`を使ってアクセス可能なドキュメント文字列があります。

特定の配列タイプの境界チェックをカスタマイズする必要がある場合は、`checkbounds(Bool, A, I...)`を特化させるべきです。しかし、ほとんどの場合、配列タイプに対して有用な`axes`を提供する限り、`checkbounds_indices`に依存できるはずです。

新しいインデックスタイプがある場合は、まず、配列の特定の次元に対して単一のインデックスを処理する `checkindex` を特化させることを検討してください。 `CartesianIndex` に似たカスタム多次元インデックスタイプがある場合は、`checkbounds_indices` を特化させることを検討する必要があるかもしれません。

この階層は、メソッドの曖昧さの可能性を減らすために設計されています。私たちは `checkbounds` を配列型に特化させる場所とし、インデックス型に対する特化は避けるようにしています。逆に、`checkindex` はインデックス型（特に最後の引数）にのみ特化することを意図しています。

## Emit bounds checks

Juliaは`--check-bounds={yes|no|auto}`を使用して起動することができ、常に境界チェックを行う、決して行わない、または`@inbounds`宣言を尊重します。
