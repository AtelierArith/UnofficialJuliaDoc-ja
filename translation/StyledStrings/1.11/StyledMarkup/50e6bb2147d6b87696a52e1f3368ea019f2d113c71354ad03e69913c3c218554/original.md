```julia
@styled_str -> AnnotatedString
```

Construct a styled string. Within the string, `{<specs>:<content>}` structures apply the formatting to `<content>`, according to the list of comma-separated specifications `<specs>`. Each spec can either take the form of a face name, an inline face specification, or a `key=value` pair. The value must be wrapped by `{...}` should it contain any of the characters `,=:{}`.

String interpolation with `$` functions in the same way as regular strings, except quotes need to be escaped. Faces, keys, and values can also be interpolated with `$`.

# Example

```julia
styled"The {bold:{italic:quick} {(foreground=#cd853f):brown} fox} jumped over the {link={https://en.wikipedia.org/wiki/Laziness}:lazy} dog"
```

# Extended help

This macro can be described by the following EBNF grammar:

```ebnf
styledstring = { styled | interpolated | escaped | plain } ;

specialchar = '{' | '}' | '$' | '\"' ;
anychar = [\u0-\u1fffff] ;
plain = { anychar - specialchar } ;
escaped = '\\', specialchar ;

interpolated = '$', ? expr ? | '$(', ? expr ?, ')' ;

styled = '{', ws, annotations, ':', content, '}' ;
content = { interpolated | plain | escaped | styled } ;
annotations = annotation | annotations, ws, ',', ws, annotation ;
annotation = face | inlineface | keyvalue ;
ws = { ' ' | '\t' | '\n' } ; (* whitespace *)

face = facename | interpolated ;
facename = [A-Za-z0-9_]+ ;

inlineface = '(', ws, [ faceprop ], { ws, ',', faceprop }, ws, ')' ;
faceprop = [a-z]+, ws, '=', ws, ( [^,)]+ | interpolated) ;

keyvalue = key, ws, '=', ws, value ;
key = ( [^\0${}=,:], [^\0=,:]* ) | interpolated ;
value = simplevalue | curlybraced | interpolated ;
curlybraced = '{' { escaped | plain } '}' ;
simplevalue = [^${},:], [^,:]* ;
```

An extra stipulation not encoded in the above grammar is that `plain` should be a valid input to [`unescape_string`](@ref), with `specialchar` kept.

The above grammar for `inlineface` is simplified, as the actual implementation is a bit more sophisticated. The full behaviour is given below.

```ebnf
faceprop = ( 'face', ws, '=', ws, ( ? string ? | interpolated ) ) |
           ( 'height', ws, '=', ws, ( ? number ? | interpolated ) ) |
           ( 'weight', ws, '=', ws, ( symbol | interpolated ) ) |
           ( 'slant', ws, '=', ws, ( symbol | interpolated ) ) |
           ( ( 'foreground' | 'fg' | 'background' | 'bg' ),
               ws, '=', ws, ( simplecolor | interpolated ) ) |
           ( 'underline', ws, '=', ws, ( underline | interpolated ) ) |
           ( 'strikethrough', ws, '=', ws, ( bool | interpolated ) ) |
           ( 'inverse', ws, '=', ws, ( bool | interpolated ) ) |
           ( 'inherit', ws, '=', ws, ( inherit | interpolated ) ) ;

nothing = 'nothing' ;
bool = 'true' | 'false' ;
symbol = [^ ,)]+ ;
hexcolor = ('#' | '0x'), [0-9a-f]{6} ;
simplecolor = hexcolor | symbol | nothing ;

underline = nothing | bool | simplecolor | underlinestyled;
underlinestyled = '(', ws, ('' | nothing | simplecolor | interpolated), ws,
                  ',', ws, ( symbol | interpolated ), ws ')' ;

inherit = ( '[', inheritval, { ',', inheritval }, ']' ) | inheritval;
inheritval = ws, ':'?, symbol ;
```
