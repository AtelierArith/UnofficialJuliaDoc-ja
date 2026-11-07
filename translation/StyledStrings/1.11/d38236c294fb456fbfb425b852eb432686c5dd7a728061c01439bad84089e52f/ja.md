```julia
loadface!(name::Symbol => update::Face)
```

`name`を`FACES``.current`の`update`とマージします。`name`が`FACES``.current`にまだ存在しない場合は、`update`に設定されます。顔をリセットするには、`update`を`nothing`に設定します。

# Examples

```jldoctest; setup = :(import StyledStrings: Face, loadface!)
julia> loadface!(:red => Face(foreground=0xff0000))
Face (sample)
    foreground: #ff0000
```
