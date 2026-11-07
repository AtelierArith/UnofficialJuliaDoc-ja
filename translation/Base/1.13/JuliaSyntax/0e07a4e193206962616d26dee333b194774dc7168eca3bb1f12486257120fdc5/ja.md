```julia
    first_child_position(stream::ParseStream, pos::ParseStreamPosition)

Find the last non-trivia child of this node (in the GreenTree/RedTree sense) and
return its position (i.e. the position as if that child had been the last thing parsed).
```
