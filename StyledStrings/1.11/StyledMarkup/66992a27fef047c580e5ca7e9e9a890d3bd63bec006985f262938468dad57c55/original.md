```
StyledMarkup
```

A sub-module of `StyledStrings` that specifically deals with parsing styled markup strings. To this end, two entrypoints are provided:

  * The [`styled""`](@ref @styled_str) string macro, which is generally preferred.
  * They [`styled`](@ref styled) function, which allows for use with runtime-provided strings, when needed.

Overall, this module essentially functions as a state machine with a few extra niceties (like detailed error reporting) sprinkled on top. The overall design can be largely summed up with the following diagram:

```text
╭String─────────╮
│ Styled markup │
╰──────┬────────╯
       │╭╴[module]
       ││
      ╭┴┴State─╮
      ╰┬───────╯
       │
 ╭╴run_state_machine!╶╮
 │              ╭─────┼─╼ escaped!
 │ Apply rules: │     │
 │  "\\" ▶──────╯ ╭───┼─╼[interpolated!] ──▶ readexpr!, addpart!
 │  "$" ▶────────╯   │
 │  "{"  ▶────────────┼─╼ begin_style! ──▶ read_annotation!
 │  "}"  ▶─────╮      │                     ├─╼ read_inlineface! [readexpr!]
 │             ╰──────┼─╼ end_style!        ╰─╼ read_face_or_keyval!
 │ addpart!(...)      │
 ╰╌╌╌╌╌┬╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯
       │
       ▼
     Result
```

Of course, as usual, the devil is in the details.
