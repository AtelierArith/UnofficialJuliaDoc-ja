```julia
isdefined(m::Module, s::Symbol, [order::Symbol])
isdefined(object, s::Symbol, [order::Symbol])
isdefined(object, index::Int, [order::Symbol])
```

グローバル変数またはオブジェクトのフィールドが定義されているかどうかを調べます。引数には、モジュールとシンボルの組み合わせ、または複合オブジェクトとフィールド名（シンボル）もしくはインデックスを指定できます。この操作には、順序付けを任意で指定できます。フィールドが `@atomic` として宣言されている場合、その指定は、その場所への書き込みと互換性があることが強く推奨されます。一方、`@atomic` として宣言されていない場合、このパラメーターを指定するには `:not_atomic` でなければなりません。

配列要素が定義されているかどうかを調べるには、代わりに [`isassigned`](@ref) を使用してください。

グローバル変数を対象とする形式は、古い Julia リリースとの互換性のためにサポートされています。新しいコードでは、[`isdefinedglobal`](@ref) を使用してください。

関連項目: [`@isdefined`](@ref)。

# Examples

```jldoctest
julia> isdefined(Base, :sum)
true

julia> isdefined(Base, :NonExistentMethod)
false

julia> a = 1//2;

julia> isdefined(a, 2)
true

julia> isdefined(a, 3)
false

julia> isdefined(a, :num)
true

julia> isdefined(a, :numerator)
false
```
