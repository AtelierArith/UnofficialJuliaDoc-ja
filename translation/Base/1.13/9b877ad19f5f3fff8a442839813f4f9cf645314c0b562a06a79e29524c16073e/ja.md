```julia
Base.summarysize(obj; count = false, exclude=Union{...}, chargeall=Union{...})::Int
```

引数から到達可能な一意なオブジェクトをすべて調べ、それらのメモリ上のサイズ（バイト単位）または占有するアロケーション数を返します。

# Keyword Arguments

  * `count`: false の場合、オブジェクトのメモリ上の合計サイズを返します。true の場合、オブジェクトが占有するアロケーション数を返します。
  * `exclude`: トラバーサルの対象から除外するオブジェクトの型を指定します。
  * `chargeall`: 通常なら除外されるフィールドも含め、フィールドのサイズを常にすべて計上するオブジェクトの型を指定します。

[`sizeof`](@ref)も参照してください。

# Examples

```jldoctest
julia> Base.summarysize(1.0)
8

julia> Base.summarysize(Ref(rand(100)))
848

julia> sizeof(Ref(rand(100)))
8

julia> Base.summarysize(Core.svec(1.0, "testing", true); count=true)
4
```
