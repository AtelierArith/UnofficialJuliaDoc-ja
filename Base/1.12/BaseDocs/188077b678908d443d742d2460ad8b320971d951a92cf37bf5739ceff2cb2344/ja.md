```julia
setfield!(value, name::Symbol, x, [order::Symbol])
setfield!(value, i::Int, x, [order::Symbol])
```

`value`の名前付きフィールドに`x`を割り当てます。`value`は可変でなければならず、`x`は`fieldtype(typeof(value), name)`のサブタイプでなければなりません。さらに、この操作のために順序を指定することができます。フィールドが`@atomic`として宣言されている場合、この指定は必須です。そうでない場合、指定されている場合は`:not_atomic`でなければなりません。詳細は[`setproperty!`](@ref Base.setproperty!)を参照してください。

# 例

```jldoctest
julia> mutable struct MyMutableStruct
           field::Int
       end

julia> a = MyMutableStruct(1);

julia> setfield!(a, :field, 2);

julia> getfield(a, :field)
2

julia> a = 1//2
1//2

julia> setfield!(a, :num, 3);
ERROR: setfield!: immutable struct of type Rational cannot be changed
```
