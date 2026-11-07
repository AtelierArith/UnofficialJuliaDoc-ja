```julia
withfaces(f, kv::Pair...)
withfaces(f, kvpair_itr)
```

`f`を実行します。`FACES``.current`は、0個以上の`:name => val`引数`kv`によって一時的に変更されます。または、`kvpair_itr`を実行して、`kv`形式の値を生成します。

`withfaces`は通常、`withfaces(kv...) do ... end`構文で使用します。`nothing`の値を指定すると、フェイスが設定されている場合に一時的に解除できます。`withfaces`が戻ると、元の`FACES``.current`が復元されています。

# Examples

```jldoctest; setup = :(import StyledStrings: Face, withfaces)
julia> withfaces(:yellow => Face(foreground=:red), :green => :blue) do
           println(styled"{yellow:red} and {green:blue} mixed make {magenta:purple}")
       end
red and blue mixed make purple
```
