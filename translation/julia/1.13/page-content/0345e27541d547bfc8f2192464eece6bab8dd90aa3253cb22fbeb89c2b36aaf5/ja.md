# Bounds checking

多くの現代的なプログラミング言語と同様に、Julia は配列へのアクセス時に境界チェックを行い、プログラムの安全性を確保します。内側のループなど、性能が特に重要な場面では、実行時の性能を向上させるために境界チェックを省略したいことがあります。たとえば、ベクトル化（SIMD）命令を生成するには、ループ本体に分岐を含めることができず、したがって境界チェックも含められません。そのため Julia には、指定したブロック内の境界チェックを省略するようコンパイラーに指示する `@inbounds(...)` マクロが用意されています。ユーザー定義の配列型では、`@boundscheck(...)` マクロを使って、コンテキストに応じたコード選択を実現できます。

## Eliding bounds checks

`@boundscheck(...)` マクロは、境界チェックを行うコードブロックを示します。このようなブロックが `@inbounds(...)` ブロックにインライン展開されると、コンパイラーによって削除されることがあります。コンパイラーが `@boundscheck` ブロックを削除するのは、呼び出し元の関数にインライン展開された場合に限られます。たとえば、次のようにメソッド `sum` を記述できます。

```julia
function sum(A::AbstractArray)
    r = zero(eltype(A))
    for i in eachindex(A)
        @inbounds r += A[i]
    end
    return r
end
```

次のようなカスタムの配列風型 `MyArray` があるとします。

```julia
@inline getindex(A::MyArray, i::Real) = (@boundscheck checkbounds(A, i); A.data[to_index(i)])
```

このとき、`getindex` が `sum` にインライン展開されると、`checkbounds(A, i)` の呼び出しは取り除かれます。関数内で複数段のインライン展開が行われる場合、削除されるのは `@boundscheck` ブロックから最大で1段深いところにあるブロックまでです。この規則により、呼び出しスタックのさらに上位にあるコードによって、プログラムの動作が意図せず変わるのを防ぎます。

### Caution!

`@inbounds` を使うと、安全でない操作を誤って公開してしまうことがあります。上の例を次のように書きたくなるかもしれません。

```julia
function sum(A::AbstractArray)
    r = zero(eltype(A))
    for i in 1:length(A)
        @inbounds r += A[i]
    end
    return r
end
```

しかし、これは1始まりのインデックスを暗黙に仮定しているため、[`OffsetArrays`](@ref man-custom-indices) と一緒に使うと、安全でないメモリアクセスが発生します。

```julia-repl
julia> using OffsetArrays

julia> sum(OffsetArray([1, 2, 3], -10))
9164911648 # inconsistent results or segfault
```

このエラーの根本原因は `1:length(A)` ですが、`@inbounds` を使うことで、境界エラーにとどまらず、検出やデバッグがより困難な安全でないメモリアクセスにつながるおそれがあります。`@inbounds` を使うメソッドが安全であることを証明するのは、困難、あるいは不可能な場合がよくあります。そのため、特に公開 API では、性能向上の利点と、セグメンテーション違反や気づきにくい誤動作のリスクを比較検討する必要があります。

## Propagating inbounds

コードの構成上の理由から、`@inbounds` 宣言と `@boundscheck` 宣言の間に、複数の層を設けたい場合もあります。たとえば、デフォルトの `getindex` メソッドでは、`getindex(A::AbstractArray, i::Real)` が `getindex(IndexStyle(A), A, i)` を呼び出し、さらに `_getindex(::IndexLinear, A, i)` を呼び出すという呼び出しの連鎖があります。

「1段のインライン展開」という規則を上書きするには、関数に [`Base.@propagate_inbounds`](@ref) を付けます。これにより、インライン展開をさらに1段経由して、インバウンズのコンテキスト（またはアウトオブバウンズのコンテキスト）を伝播できます。

## The bounds checking call hierarchy

全体の階層は次のとおりです。

  * `checkbounds(A, I...)` が次を呼び出します。

      * `checkbounds(Bool, A, I...)` が次を呼び出します。

          * `checkbounds_indices(Bool, axes(A), I)` が、各次元について再帰的に次を呼び出します。

              * `checkindex`

ここで、`A` は配列であり、`I` には「要求された」インデックスが格納されています。`axes(A)` は、`A` の「許可された」インデックスをタプルとして返します。

インデックスが無効な場合、`checkbounds(A, I...)` はエラーをスローしますが、`checkbounds(Bool, A, I...)` はその場合に `false` を返します。`checkbounds_indices` は、配列に関する情報のうち `axes` タプル以外をすべて破棄し、インデックス同士だけを比較します。これにより、比較的少数のコンパイル済みメソッドで、非常に多様な配列型に対応できます。インデックスはタプルとして指定され、通常は各次元を1対1で比較します。各次元の処理には、もう一つの重要な関数 `checkindex` が呼び出されます。一般には次のようになります。

```julia
checkbounds_indices(Bool, (IA1, IA...), (I1, I...)) = checkindex(Bool, IA1, I1) &
                                                      checkbounds_indices(Bool, IA, I)
```

したがって、`checkindex` は1つの次元をチェックします。エクスポートされていない `checkbounds_indices` を含め、これらの関数にはすべて docstring があり、`?` から参照できます。

特定の配列型について境界チェックをカスタマイズする必要がある場合は、`checkbounds(Bool, A, I...)` を特殊化してください。ただし、ほとんどの場合、配列型に適切な `axes` を用意すれば、`checkbounds_indices` に任せることができます。

独自のインデックス型がある場合は、まず、配列の特定の次元に対する単一のインデックスを処理する `checkindex` の特殊化を検討してください。`CartesianIndex` に似た独自の多次元インデックス型がある場合は、`checkbounds_indices` の特殊化が必要になることがあります。

この階層は、メソッドの曖昧さが生じる可能性を抑えるよう設計されています。配列型に応じた特殊化は `checkbounds` で行い、インデックス型に応じた特殊化はできるだけ避ける方針です。逆に、`checkindex` はインデックス型（特に最後の引数）だけに応じて特殊化することを想定しています。

## Emit bounds checks

Julia は `--check-bounds={yes|no|auto}` を指定して起動すると、境界チェックを常に行うか、まったく行わないか、あるいは `@inbounds` 宣言に従うかを設定できます。
