```julia
methods(f, [types], [module])
```

`f`のメソッドテーブルを返します。

`types`を指定すると、型が一致するメソッドの配列を返します。`module`を指定すると、そのモジュールで定義されているメソッドの配列を返します。モジュールのリストは、配列または集合として指定することもできます。

!!! compat "Julia 1.4"
    モジュールを指定するには、Julia 1.4以降が必要です。


関連項目: [`which`](@ref)、[`@which`](@ref Main.InteractiveUtils.@which)、[`methodswith`](@ref Main.InteractiveUtils.methodswith)。
