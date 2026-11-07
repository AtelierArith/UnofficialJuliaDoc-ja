```julia
begin_style!(state::State, i::Int, char::Char)
```

Parse the style declaration beginning at `i` (`char`) with `read_annotation!`, and register it in the active styles list.
