```julia
flags(x)
```

Return the flag bits of a syntactic construct. Prefer to query these with the predicates `is_trivia`, `is_prefix_call`, `is_infix_op_call`, `is_prefix_op_call`, `is_postfix_op_call`, `is_dotted`, `is_suffixed`, `is_decorated`.

Or extract numeric portion of the flags with `numeric_flags`.
