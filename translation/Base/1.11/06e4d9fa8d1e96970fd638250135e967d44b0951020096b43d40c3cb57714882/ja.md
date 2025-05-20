```
string(xs...)
```

任意の値から[`print`](@ref)関数を使用して文字列を作成します。

`string`は通常、直接定義されるべきではありません。代わりに、`print(io::IO, x::MyType)`メソッドを定義します。特定の型に対して`string(x)`が非常に効率的である必要がある場合、`string`にメソッドを追加し、`print(io::IO, x::MyType) = print(io, string(x))`を定義して、関数が一貫性を持つようにすることが意味を持つかもしれません。

参照: [`String`](@ref), [`repr`](@ref), [`sprint`](@ref), [`show`](@ref @show)。

# 例

```jldoctest
julia> string("a", 1, true)
"a1true"
```
