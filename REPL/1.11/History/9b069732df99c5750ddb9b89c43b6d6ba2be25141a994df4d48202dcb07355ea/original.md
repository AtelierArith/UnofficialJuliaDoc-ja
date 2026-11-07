```julia
print_candidate(io::IO, search::FilterSpec, cand::HistEntry, width::Int; selected::Bool, hover::Bool)
```

Render one history entry line with markers, mode hint, age, and highlighted content.

Truncates and focuses on matches to fit `width`.
