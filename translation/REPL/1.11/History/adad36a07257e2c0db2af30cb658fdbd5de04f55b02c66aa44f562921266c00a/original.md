```julia
highlightcand(cand::HistEntry) -> AnnotatedString
```

Syntax-highlight Julia content or return raw content otherwise.

Tabs are expanded to spaces, since terminals give them a width that `textwidth` does not.
