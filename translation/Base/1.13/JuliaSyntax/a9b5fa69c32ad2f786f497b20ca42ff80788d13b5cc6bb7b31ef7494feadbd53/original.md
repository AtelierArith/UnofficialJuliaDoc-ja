```julia
RawGreenNode(head::SyntaxHead, byte_span::UInt32, orig_kind::Kind) # Terminal
RawGreenNode(head::SyntaxHead, byte_span::UInt32, nchildren::UInt32) # Non-terminal
```

A "green tree" is a lossless syntax tree which overlays all the source text. The most basic properties of a green tree are that:

  * Nodes cover a contiguous span of bytes in the text
  * Sibling nodes are ordered in the same order as the text

As implementation choices, we choose that:

  * Nodes are immutable and don't know their parents or absolute position, so can be cached and reused
  * Nodes are homogeneously typed at the language level so they can be stored concretely, with the `head` defining the node type. Normally this would include a "syntax kind" enumeration, but it can also include flags and record information the parser knew about the layout of the child nodes.
  * For simplicity and uniformity, leaf nodes cover a single token in the source. This is like rust-analyzer, but different from Roslyn where leaves can include syntax trivia.
  * The parser produces a single buffer of `RawGreenNode` which encodes the tree. There are higher level accessors, which make working with this tree easier.
