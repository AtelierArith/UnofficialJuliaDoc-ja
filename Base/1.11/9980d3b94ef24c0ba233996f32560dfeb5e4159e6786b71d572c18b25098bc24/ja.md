```
axes(A, d)
```

配列 `A` の次元 `d` に沿った有効なインデックスの範囲を返します。

関連情報として [`size`](@ref) および [カスタムインデックスを持つ配列](@ref man-custom-indices) に関するマニュアルの章を参照してください。

# 例

```jldoctest
julia> A = fill(1, (5,6,7));

julia> axes(A, 2)
Base.OneTo(6)

julia> axes(A, 4) == 1:1  # ndims(A) より大きいすべての次元 d はサイズ 1
true
```

# 使用上の注意

各インデックスは `AbstractUnitRange{<:Integer}` でなければなりませんが、同時にカスタムインデックスを使用する型であることもできます。たとえば、サブセットが必要な場合は、`begin`/`end` や [`firstindex`](@ref)/[`lastindex`](@ref) のような一般化されたインデックス構造を使用してください：

```julia
ix = axes(v, 1)
ix[2:end]          # 例えばベクターでは動作しますが、一般には失敗する可能性があります
ix[(begin+1):end]  # 一般化されたインデックスでは動作します
```
