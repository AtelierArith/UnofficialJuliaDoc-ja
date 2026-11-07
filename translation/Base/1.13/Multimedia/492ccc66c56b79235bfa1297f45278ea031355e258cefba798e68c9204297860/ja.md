```julia
showable(mime, x)
```

オブジェクト `x` を指定された型 `mime` として書き出せるかどうかを示す真偽値を返します。

（デフォルトでは、`typeof(x)` に対応する [`show`](@ref) メソッドが存在するかどうかによって自動的に判定されます。一部の型では、独自の `showable` メソッドを提供します。たとえば、利用可能な MIME 形式が `x` の *値* に依存する場合です。）

# Examples

```jldoctest
julia> showable(MIME("text/plain"), rand(5))
true

julia> showable("image/png", rand(5))
false
```
