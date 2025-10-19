```julia
abstract type
```

`abstract type` はインスタンス化できない型を宣言し、型グラフのノードとしてのみ機能し、関連する具体的な型の集合を記述します：それらの具体的な型はその子孫です。抽象型は、Juliaの型システムを単なるオブジェクト実装のコレクション以上のものにする概念的な階層を形成します。例えば：

```julia
abstract type Number end
abstract type Real <: Number end
```

[`Number`](@ref) にはスーパタイプがなく、[`Real`](@ref) は `Number` の抽象サブタイプです。
