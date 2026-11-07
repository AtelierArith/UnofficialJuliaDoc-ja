```julia
eachindex(A...)
eachindex(::IndexStyle, A::AbstractArray...)
```

`AbstractArray` `A` の各インデックスを効率よく順にたどるための反復可能オブジェクトを作成します。`Array` のように高速な線形インデックスに対応した配列型では、1始まりのインデックスを使う場合、これは単に `1:length(A)` となります。高速な線形インデックスに対応していない配列型では、通常、各次元のインデックスを指定して配列を効率よくインデックス付けできる、専用の直積範囲が返されます。

一般に、`eachindex` は文字列や辞書を含む任意の反復可能オブジェクトを受け取り、不均等間隔や非整数のインデックスなど、任意の型のインデックスをサポートするイテレーターオブジェクトを返します。

`A` が `AbstractArray` の場合、最初の引数に `IndexStyle` 型の値を渡すことで、`eachindex` が返すインデックスの形式を明示的に指定できます（線形インデックスが必要なら通常は `IndexLinear()`、直積範囲が必要なら `IndexCartesian()` を指定します）。

`AbstractArray` 引数を複数指定すると、`eachindex` はすべての引数に対して高速な反復可能オブジェクトを作成します（通常、すべての入力が高速な線形インデックスに対応していれば [`UnitRange`](@ref)、そうでなければ [`CartesianIndices`](@ref)）。配列のサイズや次元数が異なる場合は、`DimensionMismatch` 例外がスローされます。

インデックスと値をまとめて反復するには [`pairs`](@ref)`(A)` を、1つの次元に沿った有効なインデックスを取得するには [`axes`](@ref)`(A, 2)` も参照してください。

# Examples

```jldoctest
julia> A = [10 20; 30 40];

julia> for i in eachindex(A) # linear indexing
           println("A[", i, "] == ", A[i])
       end
A[1] == 10
A[2] == 30
A[3] == 20
A[4] == 40

julia> for i in eachindex(view(A, 1:2, 1:1)) # Cartesian indexing
           println(i)
       end
CartesianIndex(1, 1)
CartesianIndex(2, 1)
```
