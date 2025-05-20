```
ℯ
e
```

定数 ℯ。

Unicode `ℯ` は、Julia REPL で `\euler` と入力してタブを押すことで、また多くのエディタで入力できます。

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
