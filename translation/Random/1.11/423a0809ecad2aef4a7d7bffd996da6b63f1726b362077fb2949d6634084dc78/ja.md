```julia
Random.hash_seed(seed, ctx::SHA_CTX)::AbstractVector{UInt8}
```

`ctx`を、`seed`の内容で`SHA.update!`を介して更新します。この関数は、[`SeedHasher`](@ref) RNGがランダムバイトを生成するために使用します。

現在、`seed`の型は`Union{Integer, AbstractString, AbstractArray{UInt32}, AbstractArray{UInt64}}`ですが、各モジュールは自らが所有する型に対してこの関数を拡張できます。

`hash_seed`は「単射」です。同値なコンテキストオブジェクト`cn`と`cm`について、`n != m`が成り立つ場合、`hash_seed(n, cn); hash_seed(m, cm)`の呼び出し後、`cn`と`cm`は異なる値になります。さらに、`n == m`が成り立つ場合、`hash_seed(n, cn); hash_seed(m, cm)`の呼び出し後も、`cn`と`cm`は同値のままです。
