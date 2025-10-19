```julia
detect_ambiguities(mod1, mod2...; recursive=false,
                                  ambiguous_bottom=false,
                                  allowed_undefineds=nothing)
```

指定されたモジュールで定義された曖昧なメソッドの `(Method,Method)` ペアのベクターを返します。すべてのサブモジュールでテストするには `recursive=true` を使用します。

`ambiguous_bottom` は、`Union{}` 型パラメータによってのみ引き起こされる曖昧さが含まれるかどうかを制御します。ほとんどの場合、これを `false` に設定することをお勧めします。 [`Base.isambiguous`](@ref) を参照してください。

`allowed_undefineds` の説明については、[`Test.detect_unbound_args`](@ref) を参照してください。

!!! compat "Julia 1.8"
    `allowed_undefineds` は少なくとも Julia 1.8 が必要です。

