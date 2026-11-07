```julia
Base.SecretBuffer()
```

An [`IOBuffer`](@ref)-like object where the contents will be securely wiped when garbage collected.

It is considered best practice to wipe the buffer using `Base.shred!(::SecretBuffer)` as soon as the secure data are no longer required. When initializing with existing data, the `SecretBuffer!` method is highly recommended to securely zero the passed argument. Avoid initializing with and converting to `String`s as they are unable to be securely zeroed.

# Examples

```jldoctest
julia> s = Base.SecretBuffer()
SecretBuffer("*******")

julia> write(s, 's', 'e', 'c', 'r', 'e', 't')
6

julia> seek(s, 0); Char(read(s, UInt8))
's': ASCII/Unicode U+0073 (category Ll: Letter, lowercase)

julia> Base.shred!(s)
SecretBuffer("*******")

julia> eof(s)
true
```
