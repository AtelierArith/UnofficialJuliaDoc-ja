```julia
getfield(value, name::Symbol, [order::Symbol], [boundscheck::Bool=true])
getfield(value, i::Int, [order::Symbol], [boundscheck::Bool=true])
```

複合型`value`から、名前または位置を指定してフィールドを取り出します。

この操作では、順序を指定することもできます。フィールドが`@atomic`として宣言されている場合、その指定は、その場所への書き込みと互換性があることが強く推奨されます。それ以外の場合、フィールドが`@atomic`として宣言されていなければ、このパラメーターを指定する際は`:not_atomic`でなければなりません。

境界チェックは無効にできます。その場合、`i`が範囲外であれば、この関数の動作は未定義です。

関連項目：[`getproperty`](@ref Base.getproperty)および[`fieldnames`](@ref)。

# Examples

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
