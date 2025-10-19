```julia
artifact_exists(hash::SHA1; honor_overrides::Bool=true)
```

指定されたアーティファクト（そのsha1 gitツリーハッシュによって識別される）がディスク上に存在するかどうかを返します。指定されたアーティファクトが複数の場所（例えば、複数のデポ内）に存在する可能性があることに注意してください。

!!! compat "Julia 1.3"
    この関数は少なくともJulia 1.3を必要とします。

