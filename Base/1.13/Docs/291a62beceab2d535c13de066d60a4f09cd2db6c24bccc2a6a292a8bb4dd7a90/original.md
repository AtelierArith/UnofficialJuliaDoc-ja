```julia
Docs.DocStr
```

Stores the contents of a single docstring as well as related metadata.

Both the raw text, `.text`, and the parsed markdown, `.object`, are tracked by this type. Parsing of the raw text is done lazily when a request is made to render the docstring, which helps to reduce total precompiled image size.

The `.data` fields stores several values related to the docstring, such as: path, linenumber, source code, and fielddocs.
