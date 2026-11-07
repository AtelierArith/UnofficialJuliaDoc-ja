```julia
upstream(ref::GitReference)::Union{GitReference, Nothing}
```

`ref` を含むブランチに、指定された上流ブランチがあるかどうかを確認してください。

上流ブランチが存在する場合は、そのブランチへの `GitReference` を返してください。要求されたブランチに対応する上流ブランチがない場合は、[`nothing`](@ref) を返してください。
