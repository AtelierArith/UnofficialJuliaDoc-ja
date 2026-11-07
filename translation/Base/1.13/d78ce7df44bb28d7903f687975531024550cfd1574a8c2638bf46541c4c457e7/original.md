```julia
struct TermCapability
```

Specification of a single terminal capability.

!!! warning



This is not part of the public API, and thus subject to change without notice.

# Fields

  * `name::Symbol`: The name of the terminfo capability variable
  * `capname::Symbol`: The *Cap-name* of the capability
  * `description::String`: A description of the purpose of the capability

See also: `TermInfo`, `TERM_FLAGS`, `TERM_NUMBERS`, and `TERM_STRINGS`.
