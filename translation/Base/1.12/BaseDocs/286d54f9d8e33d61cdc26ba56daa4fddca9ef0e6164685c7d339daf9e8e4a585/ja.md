```julia
public
```

`public` はモジュール内で使用され、Julia に対してモジュールのどの名前がパブリック API の一部であるかを示します。例えば、`public foo` は名前 `foo` がパブリックであることを示しますが、モジュールを [`using`](@ref) した際に利用可能にするわけではありません。

[`export`](@ref) がすでに名前がパブリックであることを示しているため、名前を `public` と `export` の両方として宣言することは不必要であり、エラーとなります。詳細については [manual section about modules](@ref modules) を参照してください。

!!! compat "Julia 1.11"
    public キーワードは Julia 1.11 で追加されました。それ以前は、パブリック性の概念はそれほど明示的ではありませんでした。

