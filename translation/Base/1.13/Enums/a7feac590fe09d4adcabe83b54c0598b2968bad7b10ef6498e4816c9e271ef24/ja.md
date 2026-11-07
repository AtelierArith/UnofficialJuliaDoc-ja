```julia
@enum EnumName[::BaseType] value1[=x] value2[=y]
```

`Enum{BaseType}` サブタイプを作成し、名前を `EnumName`、列挙メンバーの値を `value1` と `value2` にします。必要に応じて、それぞれに `x` と `y` の値を割り当てることもできます。`EnumName` は、他の型や列挙メンバーの値と同様に、通常の値として使用できます。たとえば、

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

`BaseType` は、デフォルトでは [`Int32`](@ref) となり、`Integer` のプリミティブサブタイプでなければなりません。メンバーの値は、列挙型と `BaseType` の間で変換できます。`read` と `write` は、これらの変換を自動的に行います。デフォルト以外の `BaseType` を指定して列挙型を作成した場合、`Integer(value1)` は、型が `BaseType` の整数 `value1` を返します。

列挙型のすべてのインスタンスを一覧表示するには、`instances` を使用します。たとえば、

```jldoctest fruitenum
julia> instances(Fruit)
(apple, orange, kiwi)
```

列挙型のインスタンスからシンボルを作成することもできます。

```jldoctest fruitenum
julia> Symbol(apple)
:apple
```
