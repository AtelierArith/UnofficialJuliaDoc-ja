```julia
replace(f::Function, root::Node) -> Node
```

`root`のすべての子ノードが再帰的に（後順深さ優先）`f(child)`の結果に置き換えられたツリーのコピーを作成します。

関数`f(child::Node)`は、`child`を置き換える新しい[`Node`](@ref)を返すか、`child`を置き換える兄弟として挿入されるノードのベクターを返さなければなりません。

`replace`は無効なツリーの構築を許可せず、無効な親子関係を必要とする要素の置き換え（例：インラインを期待する要素の子としてのブロック要素）はエラーをスローします。

# 例

次のスニペットは、与えられたASTからリンクを削除します。つまり、[`Link`](@ref)ノードをそのリンクテキスト（ネストされたインラインMarkdown要素を含む場合があります）に置き換えます：

```julia
new_mdast = replace(mdast) do node
    if node.element isa MarkdownAST.Link
        return [MarkdownAST.copy_tree(child) for child in node.children]
    else
        return node
    end
end
```
