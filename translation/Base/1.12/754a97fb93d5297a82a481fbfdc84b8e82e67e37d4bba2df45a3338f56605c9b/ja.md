```julia
read(s::IO, nb=typemax(Int))
```

`s`から最大`nb`バイトを読み取り、読み取ったバイトの`Vector{UInt8}`を返します。
