```julia
peek_behind(ps; skip_trivia=true, skip_parens=true)
peek_behind(ps, pos::ParseStreamPosition)
```

Return information about a span which was previously inserted into the output, defaulting to the most previous nontrivia node when `skip_trivia` is true, or at the provided position `pos`.

Retroactively inspecting or modifying the parser's output can be confusing, so using this function should be avoided where possible.
