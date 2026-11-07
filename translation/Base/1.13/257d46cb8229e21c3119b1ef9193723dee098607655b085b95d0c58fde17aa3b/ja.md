```julia
@generated f
```

`@generated`は、生成される関数を注釈するために使用します。生成された関数の本体では、引数の型のみを参照でき、値は参照できません。この関数は、呼び出し時に評価される引用式を返します。グローバルスコープを変更する関数や、変更可能な要素に依存する関数には、`@generated`マクロを使用しないでください。

詳しくは[Metaprogramming](@ref)を参照してください。

# Examples

```jldoctest
julia> @generated function bar(x)
           if x <: Integer
               return :(x ^ 2)
           else
               return :(x)
           end
       end
bar (generic function with 1 method)

julia> bar(4)
16

julia> bar("baz")
"baz"
```
