```julia
isnextchar(state::State, char::Char) -> Bool
isnextchar(state::State, chars::NTuple{N, Char}) -> Bool
```

Check if `state` has a next character, and if so whether it is `char` or one of `chars`.
