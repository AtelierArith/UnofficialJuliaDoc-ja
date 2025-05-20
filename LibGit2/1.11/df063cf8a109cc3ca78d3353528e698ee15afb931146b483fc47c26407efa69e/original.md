```
GitHash(ref::GitReference)
```

Get the identifier (`GitHash`) of the object referred to by the direct reference `ref`. Note: this does not work for symbolic references; in such cases use `GitHash(repo::GitRepo, ref_name::AbstractString)` instead.
