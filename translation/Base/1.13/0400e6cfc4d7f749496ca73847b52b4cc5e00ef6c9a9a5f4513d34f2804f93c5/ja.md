```julia
to_indices(A, I::Tuple)
```

タプル `I` を、配列 `A` のインデックス指定に使うインデックスのタプルに変換します。

返されるタプルに含められるのは、配列 `A` がサポートするスカラーインデックスの `Int` または `AbstractArray` のみです。処理方法が分からない新しいインデックス型に遭遇すると、エラーになります。

単純なインデックス型の処理は、非公開の `Base.to_index(A, i)` に委譲され、各インデックス `i` が処理されます。この内部関数を直接呼び出すことは想定されていませんが、カスタム配列型やインデックス型では、独自のインデックス処理を提供するために `Base.to_index` を拡張できます。

より複雑なインデックス型では、インデックスを適用する次元に関する情報が必要になる場合があります。そのようなケースに対応するため、`to_indices(A, I)` は `to_indices(A, axes(A), I)` を呼び出します。後者は、与えられたインデックスのタプルと `A` の次元インデックスを対応させながら、両方を再帰的にたどります。そのため、すべてのインデックス型が `Base.to_index` に引き継がれるとは限りません。

# Examples

```jldoctest
julia> A = zeros(1,2,3,4);

julia> to_indices(A, (1,1,2,2))
(1, 1, 2, 2)

julia> to_indices(A, (1,1,2,20)) # no bounds checking
(1, 1, 2, 20)

julia> to_indices(A, (CartesianIndex((1,)), 2, CartesianIndex((3,4)))) # exotic index
(1, 2, 3, 4)

julia> to_indices(A, ([1,1], 1:2, 3, 4))
([1, 1], 1:2, 3, 4)

julia> to_indices(A, (1,2)) # no shape checking
(1, 2)
```
