```julia
update!(hist::HistoryFile) -> HistoryFile
```

Read any new entries from the history file and record them as `HistEntry`s.

Malformed entries are skipped, and if the last entry is incomplete the IO position will be reset to the start of the entry.
