```julia
unsafe_pointer_to_objref(p::Ptr)
```

`Ptr`をオブジェクト参照に変換します。ポインターが有効なヒープ割り当て済みのJuliaオブジェクトを指していることを前提とします。そうでない場合、未定義動作が発生するため、この関数は「unsafe」とみなされ、注意して使用する必要があります。

関連項目: [`pointer_from_objref`](@ref)。
