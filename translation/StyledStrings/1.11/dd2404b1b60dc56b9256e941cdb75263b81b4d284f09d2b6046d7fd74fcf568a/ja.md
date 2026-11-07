```julia
addface!(name::Symbol => default::Face)
```

`name`という名前で新しいフェイスを作成します。同じ名前のフェイスがまだ存在しない場合、`default`が`FACES``.default`と、そのコピーが`FACES`に追加され、現在の値が返されます。`current`

フェイス`name`がすでに存在する場合は、`nothing`が返されます。

# Examples

```jldoctest; setup = :(import StyledStrings: Face, addface!)
julia> addface!(:mypkg_myface => Face(slant=:italic, underline=true))
Face (sample)
         slant: italic
     underline: true
```
