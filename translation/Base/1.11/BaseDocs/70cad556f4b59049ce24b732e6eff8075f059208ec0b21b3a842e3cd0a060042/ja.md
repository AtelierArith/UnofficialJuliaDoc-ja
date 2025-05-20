```
getfield(value, name::Symbol, [order::Symbol])
getfield(value, i::Int, [order::Symbol])
```

コンポジット `value` から名前または位置によってフィールドを抽出します。オプションで、操作のための順序を定義できます。フィールドが `@atomic` として宣言されている場合、その仕様はその位置へのストアと互換性があることが強く推奨されます。そうでない場合、`@atomic` として宣言されていない場合は、このパラメータは指定されている場合 `:not_atomic` でなければなりません。詳細は [`getproperty`](@ref Base.getproperty) と [`fieldnames`](@ref) を参照してください。

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
