```julia
Vararg{T,N}
```

タプル型の最後のパラメーター[`Tuple`](@ref)には、末尾に任意個の要素が続くことを表す特別な値`Vararg`を指定できます。`Vararg{T,N}`は、型`T`の要素がちょうど`N`個あることを表します。最後に、`Vararg{T}`は、型`T`の要素が0個以上あることを表します。`Vararg`タプル型は、可変長引数メソッドが受け取る引数を表すために使われます（マニュアルの[Varargs Functions](@ref)の節を参照）。

[`NTuple`](@ref)も参照してください。

# Examples

```jldoctest
julia> mytupletype = Tuple{AbstractString, Vararg{Int}}
Tuple{AbstractString, Vararg{Int64}}

julia> isa(("1",), mytupletype)
true

julia> isa(("1",1), mytupletype)
true

julia> isa(("1",1,2), mytupletype)
true

julia> isa(("1",1,2,3.0), mytupletype)
false
```
