```
last(coll)
```

順序付きコレクションの最後の要素を取得します。これはO(1)時間で計算できる場合に限ります。これは、[`lastindex`](@ref)を呼び出して最後のインデックスを取得することで実現されます。空であっても、[`AbstractRange`](@ref)の終点を返します。

他に[`first`](@ref)、[`endswith`](@ref)も参照してください。

# 例

```jldoctest
julia> last(1:2:10)
9

julia> last([1; 2; 3; 4])
4
```
