```julia
upstream(ref::GitReference)::Union{GitReference, Nothing}
```

`ref` を含むブランチに、追跡先のブランチが指定されているか確認してください。

追跡先のブランチが存在する場合は `GitReference` を返し、指定されたブランチに対応する追跡先がない場合は [`nothing`](@ref) を返してください。
