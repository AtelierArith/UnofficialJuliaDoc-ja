```
struct
```

Juliaで最も一般的に使用される型はstructで、名前とフィールドのセットとして指定されます。

```julia
struct Point
    x
    y
end
```

フィールドには型制限を設けることができ、パラメータ化することも可能です：

```julia
struct Point{X}
    x::X
    y::Float64
end
```

structは`<:`構文を使用して抽象スーパタイプを宣言することもできます：

```julia
struct Point <: AbstractPoint
    x
    y
end
```

`struct`はデフォルトで不変です。これらの型のインスタンスは構築後に変更することはできません。インスタンスを変更可能な型を宣言するには、代わりに[`mutable struct`](@ref)を使用してください。

コンストラクタの定義方法など、詳細については[Composite Types](@ref)に関するマニュアルのセクションを参照してください。
