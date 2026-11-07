```julia
struct
```

Juliaで最もよく使われる型は、名前とフィールドの集合で定義する構造体です。

```julia
struct Point
    x
    y
end
```

フィールドには型の制約を指定できます。また、その型をパラメーター化することもできます。

```julia
struct Point{X}
    x::X
    y::Float64
end
```

構造体では、`<:`構文を使って抽象スーパータイプを宣言することもできます。

```julia
struct Point <: AbstractPoint
    x
    y
end
```

`struct`はデフォルトで不変です。これらの型のインスタンスは、構築後に変更できません。インスタンスを変更可能な型を宣言するには、代わりに[`mutable struct`](@ref)を使います。

コンストラクターの定義方法など、詳しくはマニュアルの[Composite Types](@ref)の節を参照してください。
