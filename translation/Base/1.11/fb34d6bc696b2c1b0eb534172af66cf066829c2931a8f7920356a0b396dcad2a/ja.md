```
eachindex(A...)
eachindex(::IndexStyle, A::AbstractArray...)
```

`AbstractArray` `A`の各インデックスを効率的に訪問するためのイテラブルオブジェクトを作成します。高速な線形インデックスを選択した配列タイプ（`Array`など）では、これは単に`1:length(A)`の範囲になります（1ベースのインデックスを使用している場合）。高速な線形インデックスを選択していない配列タイプでは、通常、すべての次元に対して指定されたインデックスで配列に効率的にインデックスを付けるために、特化したカートesian範囲が返されます。

一般に、`eachindex`は任意のイテラブル（文字列や辞書を含む）を受け入れ、任意のインデックスタイプ（例えば、不均等に間隔を空けたインデックスや非整数インデックス）をサポートするイテレータオブジェクトを返します。

`A`が`AbstractArray`である場合、`eachindex`によって返されるインデックスのスタイルを明示的に指定することが可能であり、そのためには最初の引数として`IndexStyle`型の値を渡します（通常、線形インデックスが必要な場合は`IndexLinear()`、カートesian範囲が必要な場合は`IndexCartesian()`）。

複数の`AbstractArray`引数を供給すると、`eachindex`はすべての引数に対して高速なイテラブルオブジェクトを作成します（通常、すべての入力が高速な線形インデックスを持つ場合は[`UnitRange`](@ref)、そうでない場合は[`CartesianIndices`](@ref)）。配列のサイズや次元が異なる場合、`DimensionMismatch`例外がスローされます。

インデックスと値を一緒に反復するための[`pairs`](@ref)`(A)`や、1次元に沿った有効なインデックスのための[`axes`](@ref)`(A, 2)`も参照してください。

# 例

```jldoctest
julia> A = [10 20; 30 40];

julia> for i in eachindex(A) # 線形インデックス
           println("A[", i, "] == ", A[i])
       end
A[1] == 10
A[2] == 30
A[3] == 20
A[4] == 40

julia> for i in eachindex(view(A, 1:2, 1:1)) # カートesianインデックス
           println(i)
       end
CartesianIndex(1, 1)
CartesianIndex(2, 1)
```
