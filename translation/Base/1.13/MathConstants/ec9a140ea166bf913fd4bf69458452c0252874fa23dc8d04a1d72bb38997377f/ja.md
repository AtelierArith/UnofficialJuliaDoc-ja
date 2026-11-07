```julia
ℯ
e
```

定数 ℯ。

Unicode文字`ℯ`は、Julia REPLや多くのエディターで`\euler`と入力してTabキーを押すと入力できます。

関連項目：[`exp`](@ref)、[`cis`](@ref)、[`cispi`](@ref)。

# Examples

```jldoctest
julia> ℯ
ℯ = 2.7182818284590...

julia> log(ℯ)
1

julia> ℯ^(im)π ≈ -1
true
```
