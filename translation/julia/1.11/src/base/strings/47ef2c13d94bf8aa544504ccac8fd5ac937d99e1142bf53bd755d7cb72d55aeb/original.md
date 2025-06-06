# [Strings](@id lib-strings)

```@docs
Core.AbstractString
Core.AbstractChar
Core.Char
Base.codepoint
Base.length(::AbstractString)
Base.sizeof(::AbstractString)
Base.:*(::Union{AbstractChar, AbstractString}, ::Union{AbstractChar, AbstractString}...)
Base.:^(::Union{AbstractString, AbstractChar}, ::Integer)
Base.string
Base.repeat(::AbstractString, ::Integer)
Base.repeat(::AbstractChar, ::Integer)
Base.repr(::Any)
Core.String(::AbstractString)
Base.SubString
Base.LazyString
Base.@lazy_str
Base.transcode
Base.unsafe_string
Base.ncodeunits(::AbstractString)
Base.codeunit
Base.codeunits
Base.ascii
Base.Regex
Base.@r_str
Base.SubstitutionString
Base.@s_str
Base.@raw_str
Base.@b_str
Base.Docs.@html_str
Base.Docs.@text_str
Base.isvalid(::Any)
Base.isvalid(::Any, ::Any)
Base.isvalid(::AbstractString, ::Integer)
Base.match
Base.eachmatch
Base.RegexMatch
Base.keys(::RegexMatch)
Base.isless(::AbstractString, ::AbstractString)
Base.:(==)(::AbstractString, ::AbstractString)
Base.cmp(::AbstractString, ::AbstractString)
Base.lpad
Base.rpad
Base.findfirst(::AbstractString, ::AbstractString)
Base.findnext(::AbstractString, ::AbstractString, ::Integer)
Base.findnext(::AbstractChar, ::AbstractString, ::Integer)
Base.findlast(::AbstractString, ::AbstractString)
Base.findlast(::AbstractChar, ::AbstractString)
Base.findprev(::AbstractString, ::AbstractString, ::Integer)
Base.occursin
Base.reverse(::Union{String,SubString{String}})
Base.replace(::IO, s::AbstractString, ::Pair...)
Base.eachsplit
Base.eachrsplit
Base.split
Base.rsplit
Base.strip
Base.lstrip
Base.rstrip
Base.startswith
Base.endswith
Base.contains
Base.first(::AbstractString, ::Integer)
Base.last(::AbstractString, ::Integer)
Base.uppercase
Base.lowercase
Base.titlecase
Base.uppercasefirst
Base.lowercasefirst
Base.join
Base.chop
Base.chopprefix
Base.chopsuffix
Base.chomp
Base.thisind
Base.nextind(::AbstractString, ::Integer, ::Integer)
Base.prevind(::AbstractString, ::Integer, ::Integer)
Base.textwidth
Base.isascii
Base.iscntrl
Base.isdigit
Base.isletter
Base.islowercase
Base.isnumeric
Base.isprint
Base.ispunct
Base.isspace
Base.isuppercase
Base.isxdigit
Base.escape_string
Base.escape_raw_string
Base.unescape_string
```

## `AnnotatedString`s

!!! note
    The API for AnnotatedStrings is considered experimental and is subject to change between Julia versions.


```@docs
Base.AnnotatedString
Base.AnnotatedChar
Base.annotatedstring
Base.annotations
Base.annotate!
```
