```julia
is_immutable_argtype(argtype)::Bool
```

`argtype` オブジェクトが不変であることが既知の場合は、`true` を返します。このクエリは、`getfield_effects` と `isdefined_effects` 専用に設計されており、不変オブジェクトに適用した場合に、`getfield` / `isdefined` 呼び出しの `:consistent`-cy を証明できます。それ以外の場合は、`:consistent`-cy を証明するために、そのオブジェクトが不変でないことに加えて、グローバルオブジェクトではないことも証明する必要があります。
