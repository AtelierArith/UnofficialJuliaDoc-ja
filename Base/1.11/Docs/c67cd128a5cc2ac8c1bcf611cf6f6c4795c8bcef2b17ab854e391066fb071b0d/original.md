# Documentation

Functions, methods and types can be documented by placing a string before the definition:

```
"""
# The Foo Function
`foo(x)`: Foo the living hell out of `x`.
"""
foo(x) = ...
```

The `@doc` macro can be used directly to both set and retrieve documentation / metadata. The macro has special parsing so that the documented object may occur on the next line:

```
@doc "blah"
function foo() ...
```

By default, documentation is written as Markdown, but any object can be used as the first argument.

## Documenting objects separately from their definitions

You can document an object before or after its definition with

```
@doc "foo" function_to_doc
@doc "bar" TypeToDoc
```

For macros, the syntax is `@doc "macro doc" :(Module.@macro)` or `@doc "macro doc" :(string_macro"")` for string macros. Without the quote `:()` the expansion of the macro will be documented.

## Retrieving Documentation

You can retrieve docs for functions, macros and other objects as follows:

```
@doc foo
@doc @time
@doc md""
```

## Functions & Methods

Placing documentation before a method definition (e.g. `function foo() ...` or `foo() = ...`) will cause that specific method to be documented, as opposed to the whole function. Method docs are concatenated together in the order they were defined to provide docs for the function.
