```julia
Base.SecretBuffer()
```

[`IOBuffer`](@ref) に似たオブジェクトで、ガベージコレクション時に内容が安全に消去されます。

機密データが不要になったら、すぐに `Base.shred!(::SecretBuffer)` を使ってバッファを消去することがベストプラクティスとされています。既存のデータで初期化する場合は、渡した引数を安全にゼロ埋めするため、`SecretBuffer!` メソッドの使用を強く推奨します。`String` は安全にゼロ埋めできないため、これを使った初期化や、これへの変換は避けてください。

# Examples

```jldoctest
julia> s = Base.SecretBuffer()
SecretBuffer("*******")

julia> write(s, 's', 'e', 'c', 'r', 'e', 't')
6

julia> seek(s, 0); Char(read(s, UInt8))
's': ASCII/Unicode U+0073 (category Ll: Letter, lowercase)

julia> Base.shred!(s)
SecretBuffer("*******")

julia> eof(s)
true
```
