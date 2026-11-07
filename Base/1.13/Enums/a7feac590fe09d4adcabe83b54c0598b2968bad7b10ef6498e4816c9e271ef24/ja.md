```julia
@enum EnumName[::BaseType] value1[=x] value2[=y]
```

`Enum{BaseType}` サブタイプを作成し、名前を `EnumName` とします。列挙メンバーの値には `value1` と `value2` を指定し、それぞれに `x` と `y` を任意で割り当てることができます。`EnumName` は、通常の値として、ほかの型や列挙メンバーの値と同様に使用できます。たとえば、

# Examples

```jldoctest fruitenum
julia> @enum Fruit apple=1 orange=2 kiwi=3

julia> f(x::Fruit) = "I'm a Fruit with value: $(Int(x))"
f (generic function with 1 method)

julia> f(apple)
"I'm a Fruit with value: 1"

julia> Fruit(1)
apple::Fruit = 1
```

値は `begin` ブロック内で指定することもできます。たとえば、

```julia
@enum EnumName begin
    value1
    value2
end
```

`BaseType` は、デフォルトでは [`Int32`](@ref) となり、`Integer` のプリミティブサブタイプでなければなりません。メンバー値は、列挙型と `BaseType` の間で相互に変換できます。`read` と `write` は、これらの変換を自動的に行います。列挙型をデフォルト以外の `BaseType` で作成した場合、`Integer(value1)` は、型が `BaseType` の整数 `value1` を返します。

列挙型のすべてのインスタンスを列挙するには、`instances` を使用します。たとえば、

```jldoctest fruitenum
julia> instances(Fruit)
(apple, orange, kiwi)
```

列挙型のインスタンスからシンボルを構築することもできます。

```jldoctest fruitenum
julia> Symbol(apple)
:apple
```
