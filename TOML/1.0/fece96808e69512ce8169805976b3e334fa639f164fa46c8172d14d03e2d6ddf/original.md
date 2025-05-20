```
ParserError
```

Type that is returned from [`tryparse`](@ref) and [`tryparsefile`](@ref) when parsing fails. It contains (among others) the following fields:

  * `pos`, the position in the string when the error happened
  * `table`, the result that so far was successfully parsed
  * `type`, an error type, different for different types of errors
