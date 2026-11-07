```julia
pairs(IndexLinear(), A)
pairs(IndexCartesian(), A)
pairs(IndexStyle(A), A)
```

配列 `A` の各要素にアクセスするイテレータです。`i => x` を返します。ここで、`i` は要素のインデックス、`x = A[i]` です。`pairs(A)` と同じですが、インデックスの形式を選択できます。また、`enumerate(A)` とも似ていますが、`i` は `A` の有効なインデックスになる一方、`enumerate` は `A` のインデックスにかかわらず、常に 1 から数えます。

[`IndexLinear()`](@ref) を指定すると、`i` は整数になります。[`IndexCartesian()`](@ref) を指定すると、`i` は [`Base.CartesianIndex`](@ref) になります。`IndexStyle(A)` を指定すると、配列 `A` のネイティブなインデックス形式として定義されている形式が選択されます。

基になる配列の境界を変更すると、このイテレータは無効になります。

# Examples

```jldoctest
julia> A = ["a" "d"; "b" "e"; "c" "f"];

julia> for (index, value) in pairs(IndexStyle(A), A)
           println("$index $value")
       end
1 a
2 b
3 c
4 d
5 e
6 f

julia> S = view(A, 1:2, :);

julia> for (index, value) in pairs(IndexStyle(S), S)
           println("$index $value")
       end
CartesianIndex(1, 1) a
CartesianIndex(2, 1) b
CartesianIndex(1, 2) d
CartesianIndex(2, 2) e
```

関連項目: [`IndexStyle`](@ref)、[`axes`](@ref)。
