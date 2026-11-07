```julia
setfield!(value, name::Symbol, x, [order::Symbol])
setfield!(value, i::Int, x, [order::Symbol])
```

複合型の `value` にある名前付きフィールドへ、`x` を代入します。`value` は可変でなければならず、`x` は `fieldtype(typeof(value), name)` のサブタイプでなければなりません。また、この操作では順序を指定できます。フィールドが `@atomic` として宣言されている場合、この指定は必須です。それ以外の場合、`@atomic` として宣言されていなければ、指定する順序は `:not_atomic` でなければなりません。[`setproperty!`](@ref Base.setproperty!) も参照してください。

# Examples

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
