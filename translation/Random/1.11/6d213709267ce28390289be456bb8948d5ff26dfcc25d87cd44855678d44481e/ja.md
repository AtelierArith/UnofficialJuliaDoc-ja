```julia
randstring([rng=default_rng()], [chars], [len=8])
```

`len` の長さで、`chars` の文字からなるランダムな文字列を生成します。デフォルトでは、大文字と小文字のアルファベットおよび数字 0～9 が使われます。省略可能な引数 `rng` では乱数生成器を指定します。詳しくは [Random Numbers](@ref) を参照してください。

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
    `chars` には、[`rand`](@ref) がそこから文字をランダムに選べるものであれば、`Char` 型または `UInt8` 型（より効率的）の任意の文字コレクションを指定できます。

