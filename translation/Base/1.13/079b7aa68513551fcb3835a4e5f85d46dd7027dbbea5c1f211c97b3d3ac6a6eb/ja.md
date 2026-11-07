```julia
SecretBuffer(str::AbstractString)
```

秘密ではない文字列から`SecretBuffer`を初期化するための便利なコンストラクターです。

文字列は安全にゼロ化したり破棄したりできないため、秘密データにこのコンストラクターを使用しないでください。文字列から始めるのではなく、`SecretBuffer()`と[`write`](@ref)を使って`SecretBuffer`を段階的に構築するか、`Base.SecretBuffer!(::AbstractVector{UInt8})`コンストラクターで`Vector{UInt8}`を使用してください。
