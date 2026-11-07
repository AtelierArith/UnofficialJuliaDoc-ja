```julia
select_keymap(events::Channel{Symbol})
```

Build a REPL.LineEdit keymap that pushes symbols into `events`.

Binds arrows, page keys, Tab, Ctrl-C/D/S, and meta-< / > to `Event` or `Returns` actions for driving the prompt loop.
