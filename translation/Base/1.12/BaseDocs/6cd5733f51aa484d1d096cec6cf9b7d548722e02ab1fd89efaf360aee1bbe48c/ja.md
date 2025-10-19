```julia
getfield(value, name::Symbol, [order::Symbol])
getfield(value, i::Int, [order::Symbol])
```

名前または位置によって複合的な `value` からフィールドを抽出します。オプションで、操作のための順序を定義できます。フィールドが `@atomic` として宣言されている場合、その仕様はその位置へのストアと互換性があることが強く推奨されます。そうでない場合、`@atomic` として宣言されていない場合は、このパラメータは指定された場合 `:not_atomic` でなければなりません。 [`getproperty`](@ref Base.getproperty) および [`fieldnames`](@ref) も参照してください。

# 例

```jldoctest
julia> a = 1//2
1//2

julia> getfield(a, :num)
1

julia> a.num
1

julia> getfield(a, 1)
1
```
