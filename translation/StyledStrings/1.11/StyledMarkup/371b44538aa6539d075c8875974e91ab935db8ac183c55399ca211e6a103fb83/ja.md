```julia
read_while!(f::Function, state::Base.Stateful, lastchar::Char)
```

`state` を `f(::Char)` まで読み取ると、`false` になります。

`Stateful` が `(_, char::Char)` のペアを反復し、述語 `f(::Char)::Bool` が与えられたとき、`(str, lastchar)` を返します。ここで、`str::String` には `f(char) == true` を満たす `char` がすべて含まれ、`lastchar` は最後に確認された `char` 要素です。ただし、`state` の要素がない場合は、入力 `lastchar` になります。

# Examples

```julia-repl
julia> s = Base.Stateful(pairs("abc"));

julia> read_while!(isnumeric, s, 'w')
("", 'a')

julia> first(s) # s is mutated
2 => 'b'

julia> read_while!(isascii, Base.Stateful(pairs("123Σω")), 'k')
("123", 'Σ')

julia> read_while!(isascii, Base.Stateful(pairs("abcde")), 'α')
("abcde", 'e')

julia> read_while!(isascii , Base.Stateful(pairs("")), 'k')
("", 'k')
```
