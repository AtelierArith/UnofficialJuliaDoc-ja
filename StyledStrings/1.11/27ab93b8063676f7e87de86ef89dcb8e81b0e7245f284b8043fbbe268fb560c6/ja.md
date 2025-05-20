```
withfaces(f, kv::Pair...)
withfaces(f, kvpair_itr)
```

`f`を`FACES``.current`を一時的にゼロ個以上の`:name => val`引数`kv`または`kvpair_itr`によって生成される`kv`形式の値で修正して実行します。

`withfaces`は一般的に`withfaces(kv...) do ... end`構文を介して使用されます。`nothing`の値を使用して、フェイスを一時的に解除することができます（設定されている場合）。`withfaces`が戻ると、元の`FACES``.current`が復元されます。

# 例

```jldoctest; setup = :(import StyledStrings: Face, withfaces)
julia> withfaces(:yellow => Face(foreground=:red), :green => :blue) do
           println(styled"{yellow:red} and {green:blue} mixed make {magenta:purple}")
       end
red and blue mixed make purple
```
