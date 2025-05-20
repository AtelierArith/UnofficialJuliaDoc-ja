```
@generated f
```

`@generated` は生成される関数に注釈を付けるために使用されます。生成された関数の本体では、引数の値ではなく、引数の型のみを読み取ることができます。この関数は、関数が呼び出されたときに評価される引用された式を返します。`@generated` マクロは、グローバルスコープを変更する関数や可変要素に依存する関数には使用すべきではありません。

詳細については [Metaprogramming](@ref) を参照してください。

# 例

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
