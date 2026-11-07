```julia
detect_ambiguities(mod1, mod2...; recursive=false,
                                  ambiguous_bottom=false,
                                  allowed_undefineds=nothing)
```

指定したモジュールで定義されている、曖昧なメソッドの`(Method,Method)`ペアを返します。すべてのサブモジュールを対象にテストするには、`recursive=true`を使用します。

`ambiguous_bottom`は、`Union{}`型パラメーターだけが原因で発生する曖昧さを含めるかどうかを制御します。ほとんどの場合、`false`に設定するのがよいでしょう。[`Base.isambiguous`](@ref)を参照してください。

`allowed_undefineds`の説明については、[`Test.detect_unbound_args`](@ref)を参照してください。

!!! compat "Julia 1.8"
    `allowed_undefineds`にはJulia 1.8以降が必要です。

