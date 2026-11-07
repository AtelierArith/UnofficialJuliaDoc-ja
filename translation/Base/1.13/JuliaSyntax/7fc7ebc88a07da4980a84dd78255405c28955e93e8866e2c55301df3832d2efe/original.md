```julia
ParseStream(text::AbstractString,          index::Integer=1; version=VERSION)
ParseStream(text::IO;                                        version=VERSION)
ParseStream(text::Vector{UInt8},           index::Integer=1; version=VERSION)
ParseStream(ptr::Ptr{UInt8}, len::Integer, index::Integer=1; version=VERSION)
```

Construct a `ParseStream` from input which may come in various forms:

  * An string (zero copy for `String` and `SubString`)
  * An `IO` object (zero copy for `IOBuffer`). The `IO` object must be seekable.
  * A buffer of bytes (zero copy). The caller is responsible for preserving buffers passed as `(ptr,len)`.

A byte `index` may be provided as the position to start parsing.

ParseStream provides an IO interface for the parser which provides lexing of the source text input into tokens, manages insignificant whitespace tokens on behalf of the parser, and stores output tokens and tree nodes in a pair of output arrays.

`version` (default `VERSION`) may be used to set the syntax version to any Julia version `>= v"1.0"`. We aim to parse all Julia syntax which has been added after v"1.0", emitting an error if it's not compatible with the requested `version`.
