```julia
@enum EnumName[::BaseType] value1[=x] value2[=y]
```

`EnumName`という名前の`Enum{BaseType}`サブタイプを作成し、オプションで割り当てられた値`x`と`y`を持つ`value1`と`value2`の列挙メンバー値を持ちます。`EnumName`は他の型と同様に使用でき、列挙メンバー値は通常の値として使用できます。例えば、

# 例

```jldoctest fruitenum
julia> @enum Fruit apple=1 orange=2 kiwi=3

julia> f(x::Fruit) = "I'm a Fruit with value: $(Int(x))"
f (generic function with 1 method)

julia> f(apple)
"I'm a Fruit with value: 1"

julia> Fruit(1)
apple::Fruit = 1
```

値は`begin`ブロック内でも指定できます。例えば、

```julia
@enum EnumName begin
    value1
    value2
end
```

`BaseType`はデフォルトで[`Int32`](@ref)であり、`Integer`のプリミティブサブタイプでなければなりません。メンバー値は列挙型と`BaseType`の間で変換できます。`read`と`write`はこれらの変換を自動的に行います。非デフォルトの`BaseType`で列挙が作成された場合、`Integer(value1)`は型`BaseType`の整数`value1`を返します。

列挙のすべてのインスタンスをリストするには`instances`を使用します。例えば、

```jldoctest fruitenum
julia> instances(Fruit)
(apple, orange, kiwi)
```

列挙インスタンスからシンボルを構築することも可能です：

```jldoctest fruitenum
julia> Symbol(apple)
:apple
```
