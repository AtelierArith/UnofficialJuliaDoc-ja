```julia
withfaces(f, kv::Pair...)
withfaces(f, kvpair_itr)
```

`f`を、`FACES``.current`に0個以上の`:name => val`引数`kv`を一時的に適用して実行するか、`kvpair_itr`を実行します。これにより、`kv`形式の値が生成されます。

`withfaces`は、通常`withfaces(kv...) do ... end`構文で使用します。`nothing`の値を指定すると、設定済みのフェイスを一時的に解除できます。`withfaces`が戻ると、元の`FACES``.current`が復元されています。

# Examples

```jldoctest; setup = :(import StyledStrings: Face, withfaces)
julia> withfaces(:yellow => Face(foreground=:red), :green => :blue) do
           println(styled"{yellow:red} and {green:blue} mixed make {magenta:purple}")
       end
red and blue mixed make purple
```
