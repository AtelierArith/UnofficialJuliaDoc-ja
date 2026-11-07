```julia
prompt(message; default="")::Union{String, Nothing}
```

Displays the `message` then waits for user input. Input is terminated when a newline (\n) is encountered or EOF (^D) character is entered on a blank line. If a `default` is provided then the user can enter just a newline character to select the `default`.

See also `Base.winprompt` (for Windows) and `Base.getpass` for secure entry of passwords.

# Examples

```julia-repl
julia> your_name = Base.prompt("Enter your name");
Enter your name: Logan

julia> your_name
"Logan"
```
