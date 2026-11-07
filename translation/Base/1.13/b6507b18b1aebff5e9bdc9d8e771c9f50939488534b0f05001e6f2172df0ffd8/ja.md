```julia
string(xs...)
```

[`print`](@ref) 関数を使うと、任意の値から文字列を作成できます。

通常、`string` を直接定義するべきではありません。代わりに、`print(io::IO, x::MyType)` のメソッドを定義してください。特定の型に対する `string(x)` の効率を大幅に高める必要がある場合は、`string` にメソッドを追加し、関数間の一貫性を保つために `print(io::IO, x::MyType) = print(io, string(x))` を定義するとよいでしょう。

関連項目: [`String`](@ref)、[`repr`](@ref)、[`sprint`](@ref)、[`show`](@ref @show)。

# Examples

```jldoctest
julia> string("a", 1, true)
"a1true"
```
