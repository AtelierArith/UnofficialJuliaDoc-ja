```julia
public
```

`public`は、モジュール内で、どの名前がそのモジュールの公開APIに含まれるかをJuliaに伝えるために使います。たとえば、`public foo`は、`foo`という名前が公開されていることを示しますが、[`using`](@ref)そのモジュールから利用可能にはしません。

[`export`](@ref)はすでに名前が公開されていることを示すため、同じ名前を`public`と`export`の両方として宣言する必要はなく、エラーになります。詳しくは[manual section about modules](@ref modules)を参照してください。

!!! compat "Julia 1.11"
    publicキーワードはJulia 1.11で追加されました。それ以前は、公開性の概念はより明示的ではありませんでした。

