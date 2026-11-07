```julia
active_manifest()
active_manifest(project_file::AbstractString)
```

Return the path of the active manifest file, or the manifest file that would be used for a given `project_file`.

In a stacked environment (where multiple environments exist in the load path), this returns the manifest file for the primary (active) environment only, not the manifests from other environments in the stack. See the manual section on [Environment stacks](@ref) for more details on how stacked environments work.

See [`Project environments`](@ref project-environments) for details on the difference between a project and a manifest, and the naming options and their priority in package loading.

See also [`Base.active_project`](@ref), [`Base.set_active_project`](@ref).

!!! compat "Julia 1.13"
    This function requires at least Julia 1.13.

