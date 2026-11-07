```@meta
EditURL = "https://github.com/JuliaLang/julia/blob/master/stdlib/Serialization/docs/src/index.md"
```

# Serialization

Juliaオブジェクトのシリアライズ機能を提供します。

```@docs
Serialization.serialize
Serialization.deserialize
Serialization.writeheader
```

### Recommended File Extension

Serializationモジュールでは特定のファイル拡張子を定めていませんが、JuliaコミュニティではシリアライズされたJuliaファイルに`.jls`拡張子を使うのが一般的です。

例:

```julia
open("model.jls", "w") do io
    serialize(io, my_model)
end
```
