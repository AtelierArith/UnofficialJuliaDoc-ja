```julia
loadface!(name::Symbol => update::Face)
```

`name` のフェイスを `FACES``.current` の `update` とマージします。`name` のフェイスが `FACES``.current` にまだ存在しない場合は、`update` に設定されます。フェイスをリセットするには、`update` を `nothing` に設定します。

# Examples

```jldoctest; setup = :(import StyledStrings: Face, loadface!)
julia> loadface!(:red => Face(foreground=0xff0000))
Face (sample)
    foreground: #ff0000
```
