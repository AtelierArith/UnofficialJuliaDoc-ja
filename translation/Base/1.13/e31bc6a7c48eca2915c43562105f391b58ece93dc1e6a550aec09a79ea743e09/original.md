```julia
unsafe_string(p::Ptr{T}, [length::Integer]) where {T<:Union{UInt16,UInt32,Cwchar_t}}
unsafe_string(p::Cwstring)
```

Transcode a string from the address of a C-style (NUL-terminated) string encoded as UTF-16 (`T=UInt16`), UTF-32 (`T=UInt32`), or the system-dependent `wchar_t` (`T=Cwchar_t` or `Cwstring`), returning a `String` (UTF-8 encoding), similar to [`transcode`](@ref) but reading directly from a pointer.  (The pointer can be safely freed afterwards.) If `length` is specified (the length of the data in encoding units), the string does not have to be NUL-terminated.

This function is labeled "unsafe" because it will crash if `p` is not a valid memory address to data of the requested length (or NUL-terminated data).
