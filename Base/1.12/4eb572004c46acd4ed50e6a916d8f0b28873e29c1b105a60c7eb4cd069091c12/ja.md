```julia
get(f::Union{Function, Type}, collection, key)
```

指定されたキーに対して保存されている値を返します。キーに対するマッピングが存在しない場合は、`f()`を返します。デフォルト値を辞書に保存するには、[`get!`](@ref)を使用してください。

これは`do`ブロック構文を使用して呼び出すことを意図しています。

```julia
get(dict, key) do
    # ここでデフォルト値を計算
    time()
end
```
