```julia
modifyproperty!(x, f::Symbol, op, v, order::Symbol=:not_atomic)
```

構文 `@atomic op(x.f, v)`（およびその同等の `@atomic x.f op v`）は `modifyproperty!(x, :f, op, v, :sequentially_consistent)` を返します。ここで、最初の引数は `getproperty` 式でなければならず、原子的に修正されます。

`op(getproperty(x, f), v)` の呼び出しは、デフォルトでオブジェクト `x` のフィールド `f` に格納できる値を返さなければなりません。特に、[`setproperty!`](@ref Base.setproperty!) のデフォルトの動作とは異なり、`convert` 関数は自動的には呼び出されません。

他に [`modifyfield!`](@ref Core.modifyfield!) と [`setproperty!`](@ref Base.setproperty!) も参照してください。
