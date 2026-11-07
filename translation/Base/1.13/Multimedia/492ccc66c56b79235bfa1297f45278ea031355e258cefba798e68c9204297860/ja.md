```julia
showable(mime, x)
```

オブジェクト `x` を、指定された型 `mime` として書き出せるかどうかを示すブール値を返します。

（デフォルトでは、`typeof(x)` に対応する [`show`](@ref) メソッドが存在するかどうかによって自動的に判定されます。一部の型では、独自の `showable` メソッドが用意されています。たとえば、利用可能な MIME 形式が `x` の *値* に依存する場合です。）

# Examples

```jldoctest
julia> showable(MIME("text/plain"), rand(5))
true

julia> showable("image/png", rand(5))
false
```
