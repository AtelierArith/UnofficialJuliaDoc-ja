```julia
get(f::Union{Function, Type}, collection, key)
```

指定したキーに対応する値を返します。キーに対応するマッピングがない場合は、`f()`を返します。デフォルト値も辞書に保存するには、[`get!`](@ref)を使用してください。

これは、`do`ブロック構文で呼び出すことを想定しています。

```julia
get(dict, key) do
    # default value calculated here
    time()
end
```
