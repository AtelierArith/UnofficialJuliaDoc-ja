```julia
LibGit2.split_cfg_entry(ce::LibGit2.ConfigEntry) -> Tuple{String,String,String,String}
```

Break the `ConfigEntry` up to the following pieces: section, subsection, name, and value.

# Examples

Given the git configuration file containing:

```julia
[credential "https://example.com"]
    username = me
```

The `ConfigEntry` would look like the following:

```julia-repl
julia> entry
ConfigEntry("credential.https://example.com.username", "me")

julia> LibGit2.split_cfg_entry(entry)
("credential", "https://example.com", "username", "me")
```

Refer to the [git config syntax documentation](https://git-scm.com/docs/git-config#_syntax) for more details.
