`SyntaxToken` is a token covering a contiguous byte range in the input text.

We record only the `next_byte` here (the index of the next byte *after* the token) to avoid duplication of data between neighbouring tokens. This is more useful than recording the first byte, as it allows an initial fixed sentinel token to be used for recording the first byte of the first real token.
