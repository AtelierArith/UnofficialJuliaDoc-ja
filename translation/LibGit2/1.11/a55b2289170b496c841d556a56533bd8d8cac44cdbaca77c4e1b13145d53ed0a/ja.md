```
LibGit2.push!(w::GitRevWalker, cid::GitHash)
```

[`GitRevWalker`](@ref) `walker`をコミット`cid`で開始します。この関数は、特定の年以降のすべてのコミットに関数を適用するために使用でき、その年の最初のコミットを`cid`として渡し、結果として得られた`w`を[`LibGit2.map`](@ref)に渡すことができます。
