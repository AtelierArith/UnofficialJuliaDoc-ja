```
append!(node.children::NodeChildren, children) -> NodeChildren
```

`children`のすべての要素を`node`の子供のリストの末尾に追加します。`children`のいずれかが別の木の一部である場合、それらは最初にその木からリンク解除されます（[`unlink!`](@ref）を参照）。子供のイテレータを返します。

!!! warning "追加中のエラー"
    この操作は原子性がなく、`append!`中にエラーが発生した場合（例えば、`children`に間違った型の要素が含まれている場合）、新しい子供の部分的な追加が発生する可能性があります。これは、配列に対する`append!`の動作に似ています（[JuliaLang/julia#15868](https://github.com/JuliaLang/julia/issues/15868）を参照）。

