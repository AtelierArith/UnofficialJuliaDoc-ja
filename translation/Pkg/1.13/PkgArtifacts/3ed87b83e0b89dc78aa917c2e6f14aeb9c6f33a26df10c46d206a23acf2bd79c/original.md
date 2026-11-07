```julia
create_artifact(f::Function)
```

Creates a new artifact by running `f(artifact_path)`, hashing the result, and moving it to the artifact store (`~/.julia/artifacts` on a typical installation).  Returns the identifying tree hash of this artifact.
