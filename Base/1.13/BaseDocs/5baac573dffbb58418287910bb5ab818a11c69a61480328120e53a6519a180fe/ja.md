```julia
modifyproperty!(x, f::Symbol, op, v, order::Symbol=:not_atomic)
```

構文 `@atomic op(x.f, v)`（および同等の `@atomic x.f op v`）は `modifyproperty!(x, :f, op, v, :sequentially_consistent)` を返します。第1引数には `getproperty` 式を指定する必要があり、その式はアトミックに変更されます。

`op(getproperty(x, f), v)` の呼び出しは、デフォルトでオブジェクト `x` のフィールド `f` に格納できる値を返す必要があります。特に、[`setproperty!`](@ref Base.setproperty!) のデフォルトの動作とは異なり、`convert` 関数は自動的には呼び出されません。

[`modifyfield!`](@ref Core.modifyfield!) および [`setproperty!`](@ref Base.setproperty!) も参照してください。
