```
loadface!(name::Symbol => update::Face)
```

`FACES``.current`にある顔`name`を`update`とマージします。もし顔`name`が`FACES``.current`にまだ存在しない場合、`update`に設定されます。顔をリセットするには、`update`を`nothing`に設定できます。

# 例

```jldoctest; setup = :(import StyledStrings: Face, loadface!)
julia> loadface!(:red => Face(foreground=0xff0000))
Face (sample)
    foreground: #ff0000
```
