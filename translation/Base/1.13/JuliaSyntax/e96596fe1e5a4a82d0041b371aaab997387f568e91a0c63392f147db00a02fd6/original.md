```julia
Diagnostic(first_byte, last_byte; [error="msg" | warning="msg"])
```

A diagnostic message, referring to the source code byte range first*byte:last*byte, with a `warning` or `error` message.

Messages should be concise, matter-of-fact and not include decorations:

  * Concise: "Show don't tell". Where possible, let's show the user what's wrong by annotating their original source code via the byte range.
  * Matter-of-fact: Admonishing the user isn't helpful. Let's gently show them what's wrong instead, using a neutral tone.
  * Decorations: Capitalization, punctuation and diagnostic class ("error" / "warning") should be omitted. These decorations will be added by the formatting code.

TODO: At some point we should enhance Diagnostic to allow multiple sub-ranges for better annotation. Let's follow the excellent precedent set by Rust's [rustc_errors::Diagnostic](https://doc.rust-lang.org/stable/nightly-rustc/rustc_errors/struct.Diagnostic.html).

TODO: We should cater for extended descriptions containing multiple sentences via a diagnostic code which can be used to look up detailed information. Again, Rust does this well.
