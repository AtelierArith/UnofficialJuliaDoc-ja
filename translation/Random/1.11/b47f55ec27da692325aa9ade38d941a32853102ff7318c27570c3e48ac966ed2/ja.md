```
randstring([rng=default_rng()], [chars], [len=8])
```

長さ `len` のランダムな文字列を作成します。これは `chars` から構成され、デフォルトでは大文字と小文字のアルファベットおよび数字 0-9 のセットになります。オプションの `rng` 引数は乱数生成器を指定します。詳細は [Random Numbers](@ref) を参照してください。

# 例

```jldoctest
julia> Random.seed!(3); randstring()
"Lxz5hUwn"

julia> randstring(Xoshiro(3), 'a':'z', 6)
"iyzcsm"

julia> randstring("ACGT")
"TGCTCCTC"
```

!!! note
    `chars` は、`Char` または `UInt8` 型の任意の文字のコレクションであり、[`rand`](@ref) がそこからランダムに文字を選択できる限り、使用できます。

