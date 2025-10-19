```julia
prepend!(node.children::NodeChildren, children) -> NodeChildren
```

`node`の子供のリストの先頭に、イテラブル`children`のすべての要素を追加します。`children`のいずれかが別の木の一部である場合、それらは最初にその木からリンク解除されます（[`unlink!`](@ref]を参照）。子供に対するイテレータを返します。

!!! warning "prepend中のエラー"
    この操作は原子性がなく、`prepend!`中にエラーが発生した場合（例えば、`children`に不正な型の要素が含まれている場合）、新しい子供の部分的な追加が発生する可能性があります。これは、配列に対する`append!`の動作に似ています（[JuliaLang/julia#15868](https://github.com/JuliaLang/julia/issues/15868)を参照）。

