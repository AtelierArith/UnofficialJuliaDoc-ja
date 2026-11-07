```julia
randstring([rng=default_rng()], [chars], [len=8])
```

`chars` の文字からなる、長さ `len` のランダムな文字列を作成します。デフォルトでは、大文字と小文字のアルファベットおよび数字 0～9 が使われます。省略可能な引数 `rng` では乱数生成器を指定します。詳細は [Random Numbers](@ref) を参照してください。

# Examples

```jldoctest
julia> Random.seed!(3); randstring()
"Lxz5hUwn"

julia> randstring(Xoshiro(3), 'a':'z', 6)
"iyzcsm"

julia> randstring("ACGT")
"TGCTCCTC"
```

!!! note
    `chars` には、[`rand`](@ref) がそこから文字をランダムに選べる限り、`Char` 型または `UInt8` 型（より効率的）など、任意の文字コレクションを指定できます。

