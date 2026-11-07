# Bounds checking

多くの現代的なプログラミング言語と同様に、Julia は配列へのアクセス時にプログラムの安全性を確保するため、境界チェックを行います。タイトな内側ループなど、パフォーマンスが重要な場面では、実行時性能を向上させるために境界チェックを省略したいことがあります。たとえば、ベクトル化（SIMD）命令を生成するには、ループ本体に分岐を含めることができないため、境界チェックも含められません。そのため Julia には、指定したブロック内で境界チェックを省略するようコンパイラーに指示する `@inbounds(...)` マクロが用意されています。ユーザー定義の配列型では、`@boundscheck(...)` マクロを使って、コンテキストに応じたコード選択を実現できます。

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

次のような、配列に似た独自の型 `MyArray` があるとします。

```julia
@inline getindex(A::MyArray, i::Real) = (@boundscheck checkbounds(A, i); A.data[to_index(i)])
```

このとき、`getindex` が `sum` にインライン展開されると、`checkbounds(A, i)` の呼び出しは省略されます。関数内で複数段階のインライン展開が行われる場合、削除されるのは `@boundscheck` ブロックから見て、インライン展開が最大1段階深いものまでです。この規則により、呼び出しスタックのさらに上位にあるコードによって、プログラムの動作が意図せず変わるのを防ぎます。

### Caution!

`@inbounds` を使うと、安全でない操作をうっかり公開してしまうおそれがあります。上の例を次のように書きたくなるかもしれません。

```julia
function sum(A::AbstractArray)
    r = zero(eltype(A))
    for i in 1:length(A)
        @inbounds r += A[i]
    end
    return r
end
```

しかし、これは暗黙に1始まりのインデックスを仮定しているため、[`OffsetArrays`](@ref man-custom-indices) と併用すると、安全でないメモリアクセスを引き起こします。

```julia-repl
julia> using OffsetArrays

julia> sum(OffsetArray([1, 2, 3], -10))
9164911648 # inconsistent results or segfault
```

ここでエラーの根本原因は `1:length(A)` ですが、`@inbounds` を使うことで、境界エラーが、検出やデバッグがより困難な安全でないメモリアクセスへと深刻化します。`@inbounds` を使うメソッドが安全であることを証明するのは、困難、あるいは不可能な場合がよくあります。そのため、特に公開 API では、性能向上の利点と、セグメンテーション違反や気づきにくい誤動作のリスクを比較検討する必要があります。

## Propagating inbounds

コードの構成上の理由から、`@inbounds` 宣言と `@boundscheck` 宣言の間に、複数の層を設けたい場合もあります。たとえば、既定の `getindex` メソッドでは、`getindex(A::AbstractArray, i::Real)` が `getindex(IndexStyle(A), A, i)` を呼び出し、さらに `_getindex(::IndexLinear, A, i)` を呼び出すという呼び出しの連鎖があります。

「インライン展開は1段階まで」という規則を上書きするには、関数に [`Base.@propagate_inbounds`](@ref) を付けます。これにより、インライン展開をさらに1段階進んだ先まで、インバウンズのコンテキスト（またはアウトオブバウンズのコンテキスト）を伝播できます。

## The bounds checking call hierarchy

全体の階層は次のとおりです。

  * `checkbounds(A, I...)` が次を呼び出す

      * `checkbounds(Bool, A, I...)` が次を呼び出す

          * `checkbounds_indices(Bool, axes(A), I)` が再帰的に次を呼び出す

              * 各次元について `checkindex`

ここで、`A` は配列、`I` は「要求された」インデックスを含みます。`axes(A)` は、`A` の「許可された」インデックスをタプルとして返します。

`checkbounds(A, I...)` はインデックスが無効な場合にエラーをスローしますが、`checkbounds(Bool, A, I...)` はその場合に `false` を返します。`checkbounds_indices` は、配列に関する情報のうち `axes` タプル以外をすべて破棄し、インデックス同士だけを比較します。これにより、比較的少数のコンパイル済みメソッドで、非常に多様な配列型に対応できます。インデックスはタプルで指定され、通常は1対1で比較されます。各次元の処理には、もう1つの重要な関数 `checkindex` が呼び出されます。一般に、次のようになります。

```julia
checkbounds_indices(Bool, (IA1, IA...), (I1, I...)) = checkindex(Bool, IA1, I1) &
                                                      checkbounds_indices(Bool, IA, I)
```

したがって、`checkindex` は単一の次元をチェックします。非エクスポートの `checkbounds_indices` を含め、これらの関数にはすべて `?` から参照できるドキュメント文字列があります。

特定の配列型に対して境界チェックをカスタマイズする必要がある場合は、`checkbounds(Bool, A, I...)` を特殊化してください。ただし、ほとんどの場合、配列型に適切な `axes` を用意すれば、`checkbounds_indices` をそのまま利用できます。

独自のインデックス型がある場合は、まず、配列の特定の次元に対する単一のインデックスを処理する `checkindex` の特殊化を検討してください。独自の多次元インデックス型（`CartesianIndex` に類似したもの）がある場合は、`checkbounds_indices` の特殊化が必要になることがあります。

この階層は、メソッドの曖昧さが生じる可能性を減らすよう設計されています。配列型に応じた特殊化は `checkbounds` で行い、インデックス型に応じた特殊化は避ける方針です。反対に、`checkindex` はインデックス型（特に最後の引数）に対してのみ特殊化することを想定しています。

## Emit bounds checks

Julia は `--check-bounds={yes|no|auto}` を指定して起動すると、境界チェックを常に行う、決して行わない、または `@inbounds` 宣言に従うよう設定できます。
