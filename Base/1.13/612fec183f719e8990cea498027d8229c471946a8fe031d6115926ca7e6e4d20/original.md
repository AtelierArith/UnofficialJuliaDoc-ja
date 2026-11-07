```julia
escape_microsoft_c_args(args::Union{Cmd,AbstractString...})
escape_microsoft_c_args(io::IO, args::Union{Cmd,AbstractString...})
```

Convert a collection of string arguments into a string that can be passed to many Windows command-line applications.

Microsoft Windows passes the entire command line as a single string to the application (unlike POSIX systems, where the shell splits the command line into a list of arguments). Many Windows API applications (including julia.exe), use the conventions of the [Microsoft C/C++ runtime](https://docs.microsoft.com/en-us/cpp/c-language/parsing-c-command-line-arguments) to split that command line into a list of strings.

This function implements an inverse for a parser compatible with these rules. It joins command-line arguments to be passed to a Windows C/C++/Julia application into a command line, escaping or quoting the meta characters space, TAB, double quote and backslash where needed.

See also [`Base.shell_escape_wincmd()`](@ref), [`Base.escape_raw_string()`](@ref).
