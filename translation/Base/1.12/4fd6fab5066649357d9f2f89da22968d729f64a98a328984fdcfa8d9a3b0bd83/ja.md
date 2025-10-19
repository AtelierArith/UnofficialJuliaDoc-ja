```julia
methods(f, [types], [module])
```

`f`のメソッドテーブルを返します。

`types`が指定されている場合、型が一致するメソッドの配列を返します。`module`が指定されている場合、そのモジュールで定義されたメソッドの配列を返します。モジュールのリストも配列またはセットとして指定できます。

!!! compat "Julia 1.4"
    モジュールを指定するには少なくともJulia 1.4が必要です。


参照: [`which`](@ref), [`@which`](@ref Main.InteractiveUtils.@which) および [`methodswith`](@ref Main.InteractiveUtils.methodswith).
