```julia
prev_sibling_assumed(cursor::GreenTreeCursor)::Union{Nothing, GreenTreeCursor}
prev_sibling_assumed(cursor::RedTreeCursor)::Union{Nothing, RedTreeCursor}
```

Gives the previous sibling of the current node, but makes the assumption that there is one or that we are at the top level. Without knowing the parent, we cannot otherwise know which the last sibling is, unless we are at the top level in which case `nothing` is returned.
