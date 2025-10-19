```julia
showable(mime, x)
```

オブジェクト `x` が指定された `mime` タイプとして書き込むことができるかどうかを示すブール値を返します。

（デフォルトでは、これは `typeof(x)` に対する対応する [`show`](@ref) メソッドの存在によって自動的に決定されます。一部の型はカスタム `showable` メソッドを提供します。たとえば、利用可能なMIMEフォーマットが `x` の*値*に依存する場合です。）

# 例

```jldoctest
julia> showable(MIME("text/plain"), rand(5))
true

julia> showable("image/png", rand(5))
false
```
