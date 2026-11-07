```julia
find_terminfo_file(term::String)
```

Locate the terminfo file for `term`, return `nothing` if none could be found.

The lookup policy is described in `terminfo(5)` "Fetching Compiled Descriptions". A terminfo database is included by default with Julia and is taken to be the first entry of `@TERMINFO_DIRS@`.
