```julia
prev_sibling_assumed(cursor::GreenTreeCursor)::Union{Nothing, GreenTreeCursor}
prev_sibling_assumed(cursor::RedTreeCursor)::Union{Nothing, RedTreeCursor}
```

現在のノードの直前の兄弟ノードを返します。ただし、兄弟ノードが存在するか、現在のノードが最上位にあることを前提とします。親ノードがわからない場合、どのノードが最後の兄弟ノードなのかは判断できません。ただし、現在のノードが最上位にある場合は、`nothing` が返されます。
