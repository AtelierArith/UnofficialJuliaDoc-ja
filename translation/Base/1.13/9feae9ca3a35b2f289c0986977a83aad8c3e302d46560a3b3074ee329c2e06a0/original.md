```julia
eachline(io::IO=stdin; keep::Bool=false)
eachline(filename::AbstractString; keep::Bool=false)
```

Create an iterable `EachLine` object that will yield each line from an I/O stream or a file. Iteration calls [`readline`](@ref) on the stream argument repeatedly with `keep` passed through, determining whether trailing end-of-line characters are retained. When called with a file name, the file is opened once at the beginning of iteration and closed at the end. If iteration is interrupted, the file will be closed when the `EachLine` object is garbage collected.

To iterate over each line of a `String`, `eachline(IOBuffer(str))` can be used.

[`Iterators.reverse`](@ref) can be used on an `EachLine` object to read the lines in reverse order (for files, buffers, and other I/O streams supporting [`seek`](@ref)), and [`first`](@ref) or [`last`](@ref) can be used to extract the initial or final lines, respectively.

# Examples

```jldoctest
julia> write("my_file.txt", "JuliaLang is a GitHub organization.\n It has many members.\n");

julia> for line in eachline("my_file.txt")
           print(line)
       end
JuliaLang is a GitHub organization. It has many members.

julia> rm("my_file.txt");
```

!!! compat "Julia 1.8"
    Julia 1.8 is required to use `Iterators.reverse` or `last` with `eachline` iterators.

