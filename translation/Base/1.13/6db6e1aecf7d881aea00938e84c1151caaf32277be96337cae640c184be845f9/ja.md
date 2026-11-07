```julia
SecretBuffer!(data::Vector{UInt8})
```

`data`から新しい`SecretBuffer`を初期化し、その後`data`を安全にゼロ化します。
