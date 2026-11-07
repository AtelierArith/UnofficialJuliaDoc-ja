```julia
export
```

`export`は、モジュール内で、どの名前をユーザーが利用できるようにするかをJuliaに伝えるために使われます。たとえば、`export foo`を使うと、モジュールを[`using`](@ref)したときに、名前`foo`が利用可能になります。詳しくは[manual section about modules](@ref modules)を参照してください。
