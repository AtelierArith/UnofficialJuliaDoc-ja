```julia
read_while!(f::Function, state::Base.Stateful, lastchar::Char)
```

Read `state` until `f(::Char)` is `false`.

Given a `Stateful` that iterates `(_, char::Char)` pairs, and a predicate `f(::Char)::Bool`, return `(str, lastchar)`, where `str::String` contains all the `char` for which `f(char) == true`, and `lastchar` the last `char` element seen, or the input `lastchar` there are no elements of `state`.

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
