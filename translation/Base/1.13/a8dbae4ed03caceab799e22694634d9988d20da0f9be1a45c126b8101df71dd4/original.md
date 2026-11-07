```julia
shell_escape_csh(args::Union{Cmd,AbstractString...})
shell_escape_csh(io::IO, args::Union{Cmd,AbstractString...})
```

This function quotes any metacharacters in the string arguments such that the string returned can be inserted into a command-line for interpretation by the Unix C shell (csh, tcsh), where each string argument will form one word.

In contrast to a POSIX shell, csh does not support the use of the backslash as a general escape character in double-quoted strings. Therefore, this function wraps strings that might contain metacharacters in single quotes, except for parts that contain single quotes, which it wraps in double quotes instead. It switches between these types of quotes as needed. Linefeed characters are escaped with a backslash.

This function should also work for a POSIX shell, except if the input string contains a linefeed (`"\n"`) character.

See also: [`Base.shell_escape_posixly()`](@ref)
