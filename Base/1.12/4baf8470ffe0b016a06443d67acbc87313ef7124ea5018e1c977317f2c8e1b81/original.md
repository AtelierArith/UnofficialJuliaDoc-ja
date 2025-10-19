```julia
shell_escape_wincmd(s::AbstractString)
shell_escape_wincmd(io::IO, s::AbstractString)
```

The unexported `shell_escape_wincmd` function escapes Windows `cmd.exe` shell meta characters. It escapes `()!^<>&|` by placing a `^` in front. An `@` is only escaped at the start of the string. Pairs of `"` characters and the strings they enclose are passed through unescaped. Any remaining `"` is escaped with `^` to ensure that the number of unescaped `"` characters in the result remains even.

Since `cmd.exe` substitutes variable references (like `%USER%`) *before* processing the escape characters `^` and `"`, this function makes no attempt to escape the percent sign (`%`), the presence of `%` in the input may cause severe breakage, depending on where the result is used.

Input strings with ASCII control characters that cannot be escaped (NUL, CR, LF) will cause an `ArgumentError` exception.

The result is safe to pass as an argument to a command call being processed by `CMD.exe /S /C " ... "` (with surrounding double-quote pair) and will be received verbatim by the target application if the input does not contain `%` (else this function will fail with an ArgumentError). The presence of `%` in the input string may result in command injection vulnerabilities and may invalidate any claim of suitability of the output of this function for use as an argument to cmd (due to the ordering described above), so use caution when assembling a string from various sources.

This function may be useful in concert with the `windows_verbatim` flag to [`Cmd`](@ref) when constructing process pipelines.

```julia
wincmd(c::String) =
   run(Cmd(Cmd(["cmd.exe", "/s /c \" $c \""]);
           windows_verbatim=true))
wincmd_echo(s::String) =
   wincmd("echo " * Base.shell_escape_wincmd(s))
wincmd_echo("hello $(ENV["USERNAME"]) & the \"whole\" world! (=^I^=)")
```

But take note that if the input string `s` contains a `%`, the argument list and echo'ed text may get corrupted, resulting in arbitrary command execution. The argument can alternatively be passed as an environment variable, which avoids the problem with `%` and the need for the `windows_verbatim` flag:

```julia
cmdargs = Base.shell_escape_wincmd("Passing args with %cmdargs% works 100%!")
run(setenv(`cmd /C echo %cmdargs%`, "cmdargs" => cmdargs))
```

!!! warning
    The argument parsing done by CMD when calling batch files (either inside `.bat` files or as arguments to them) is not fully compatible with the output of this function. In particular, the processing of `%` is different.


!!! important
    Due to a peculiar behavior of the CMD parser/interpreter, each command after a literal `|` character (indicating a command pipeline) must have `shell_escape_wincmd` applied twice since it will be parsed twice by CMD. This implies ENV variables would also be expanded twice! For example:

    ```julia
    to_print = "All for 1 & 1 for all!"
    to_print_esc = Base.shell_escape_wincmd(Base.shell_escape_wincmd(to_print))
    run(Cmd(Cmd(["cmd", "/S /C \" break | echo $(to_print_esc) \""]), windows_verbatim=true))
    ```


With an I/O stream parameter `io`, the result will be written there, rather than returned as a string.

See also [`Base.escape_microsoft_c_args()`](@ref), [`Base.shell_escape_posixly()`](@ref).

# Examples

```jldoctest
julia> Base.shell_escape_wincmd("a^\"^o\"^u\"")
"a^^\"^o\"^^u^\""
```
