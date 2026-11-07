```julia
redisplay_prompt(io::IO, oldstate::SelectorState, newstate::SelectorState, pstate::PromptState)
```

Redraw just the prompt line with updated query, separators, and hints.

Styles prefixes, match-type indicators, and result counts based on cursor position in `pstate`.
