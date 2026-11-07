```julia
LibGit2.push!(w::GitRevWalker, cid::GitHash)
```

[`GitRevWalker`](@ref) `walker`をコミット`cid`から開始します。この関数を使うと、特定の年の最初のコミットを`cid`として渡し、その結果の`w`を[`LibGit2.map`](@ref)に渡すことで、その年以降のすべてのコミットに関数を適用できます。
