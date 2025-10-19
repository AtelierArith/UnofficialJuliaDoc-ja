```julia
sizeof(T::DataType)
sizeof(obj)
```

与えられた `DataType` `T` の標準的なバイナリ表現のサイズ（バイト単位）。または、`obj` が `DataType` でない場合のオブジェクト `obj` のサイズ（バイト単位）。

関連情報は [`Base.summarysize`](@ref) を参照してください。

# 例

```jldoctest
julia> sizeof(Float32)
4

julia> sizeof(ComplexF64)
16

julia> sizeof(1.0)
8

julia> sizeof(collect(1.0:10.0))
80

julia> struct StructWithPadding
           x::Int64
           flag::Bool
       end

julia> sizeof(StructWithPadding) # パディングのため、フィールドの `sizeof` の合計ではない
16

julia> sizeof(Int64) + sizeof(Bool) # 上記とは異なる
9
```

`DataType` `T` に特定のサイズがない場合、エラーが発生します。

```jldoctest
julia> sizeof(AbstractArray)
ERROR: 抽象型 AbstractArray には明確なサイズがありません。
Stacktrace:
[...]
```
