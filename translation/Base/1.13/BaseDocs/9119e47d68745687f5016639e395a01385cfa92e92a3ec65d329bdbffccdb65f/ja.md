```julia
abstract type
```

`abstract type`はインスタンス化できない型を宣言します。型グラフのノードとしてのみ機能し、関連する具象型の集合、すなわちその子孫にあたる具象型を表します。抽象型は概念上の階層を形成し、Juliaの型システムを単なるオブジェクト実装の集合以上のものにしています。たとえば、次のようになります。

```julia
abstract type Number end
abstract type Real <: Number end
```

[`Number`](@ref)にはスーパータイプがありません。一方、[`Real`](@ref)は`Number`の抽象サブタイプです。
