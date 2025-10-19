```julia
ℯ
e
```

定数 ℯ。

Unicode `ℯ` は、Julia REPLや多くのエディタで `\euler` と入力してタブを押すことで入力できます。

参照: [`exp`](@ref), [`cis`](@ref), [`cispi`](@ref)。

# 例

```jldoctest
julia> ℯ
ℯ = 2.7182818284590...

julia> log(ℯ)
1

julia> ℯ^(im)π ≈ -1
true
```
