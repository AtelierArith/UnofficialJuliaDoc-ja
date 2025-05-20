```
addface!(name::Symbol => default::Face)
```

名前 `name` の新しいフェイスを作成します。この名前のフェイスがすでに存在しない限り、`default` が `FACES``.default` と (そのコピーが) `FACES`.`current` に追加され、現在の値が返されます。

フェイス `name` がすでに存在する場合、`nothing` が返されます。

# 例

```jldoctest; setup = :(import StyledStrings: Face, addface!)
julia> addface!(:mypkg_myface => Face(slant=:italic, underline=true))
Face (sample)
         slant: italic
     underline: true
```
