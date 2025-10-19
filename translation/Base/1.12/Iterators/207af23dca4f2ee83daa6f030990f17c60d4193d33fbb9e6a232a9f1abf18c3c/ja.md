```julia
pairs(IndexLinear(), A)
pairs(IndexCartesian(), A)
pairs(IndexStyle(A), A)
```

配列 `A` の各要素にアクセスするイテレータで、`i => x` を返します。ここで `i` は要素のインデックスで、`x = A[i]` です。`pairs(A)` と同じですが、インデックスのスタイルを選択できます。また、`enumerate(A)` に似ていますが、`i` は `A` の有効なインデックスであり、`enumerate` は常に1からカウントします。

[`IndexLinear()`](@ref) を指定すると、`i` は整数になります。[`IndexCartesian()`](@ref) を指定すると、`i` は [`Base.CartesianIndex`](@ref) になります。`IndexStyle(A)` を指定すると、配列 `A` のネイティブインデックススタイルとして定義されているものが選択されます。

基になる配列の境界を変更すると、このイテレータは無効になります。

# 例

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

他にも [`IndexStyle`](@ref)、[`axes`](@ref) を参照してください。
