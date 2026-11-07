Reset kind or flags of an existing node in the output stream

This is a hack, but in some limited occasions the trailing syntax may change the kind or flags of a token in a way which would require unbounded lookahead in a recursive descent parser. Modifying the output with reset_node! is useful in those cases.
