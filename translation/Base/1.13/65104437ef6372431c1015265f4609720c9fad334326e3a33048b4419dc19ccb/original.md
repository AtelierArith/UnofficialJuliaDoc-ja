```julia
@__DIR__ -> String
```

Macro to obtain the absolute path of the current directory as a string.

If in a script, returns the directory of the script containing the `@__DIR__` macrocall. If run from a REPL or if evaluated by `julia -e <expr>`, returns the current working directory.

# Examples

The example illustrates the difference in the behaviors of `@__DIR__` and `pwd()`, by creating a simple script in a different directory than the current working one and executing both commands:

```julia-repl
julia> cd("/home/JuliaUser") # working directory

julia> # create script at /home/JuliaUser/Projects
       open("/home/JuliaUser/Projects/test.jl","w") do io
           print(io, """
               println("@__DIR__ = ", @__DIR__)
               println("pwd() = ", pwd())
           """)
       end

julia> # outputs script directory and current working directory
       include("/home/JuliaUser/Projects/test.jl")
@__DIR__ = /home/JuliaUser/Projects
pwd() = /home/JuliaUser
```
