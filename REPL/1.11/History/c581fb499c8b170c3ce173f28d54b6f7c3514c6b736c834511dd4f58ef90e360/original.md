```julia
create_prompt(events::Channel{Symbol}, term, prefix, terminal_properties)
```

Initialize a custom REPL prompt tied to `events` using the existing `term`.

The `terminal_properties` from the main REPL's MIState are shared with the history search's MIState so that DA1/OSC responses parsed by the keymap update the same object.

Returns a tuple `(term, prompt, istate, pstate)` ready for input handling and display.
