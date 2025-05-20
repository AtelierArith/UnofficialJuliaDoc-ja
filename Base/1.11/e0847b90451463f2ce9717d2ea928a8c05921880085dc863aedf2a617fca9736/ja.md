```
ismutable(v) -> Bool
```

値 `v` がミュータブルである場合にのみ `true` を返します。イミュータビリティについての議論は [Mutable Composite Types](@ref) を参照してください。この関数は値に対して動作するため、`DataType` を与えると、その型の値がミュータブルであると教えてくれます。

!!! note
    技術的な理由から、`ismutable` は特定の特殊型（例えば `String` や `Symbol`）の値に対して `true` を返しますが、これらは許可された方法で変更できません。


他にも [`isbits`](@ref)、[`isstructtype`](@ref) を参照してください。

# 例

```jldoctest
julia> ismutable(1)
false

julia> ismutable([1,2])
true
```

!!! compat "Julia 1.5"
    この関数は少なくとも Julia 1.5 が必要です。

