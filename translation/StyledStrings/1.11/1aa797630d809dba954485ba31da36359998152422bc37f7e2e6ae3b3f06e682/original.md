```
resetfaces!(name::Symbol)
```

Reset the face `name` to its default value, which is returned.

If the face `name` does not exist, nothing is done and `nothing` returned. In the unlikely event that the face `name` does not have a default value, it is deleted, a warning message is printed, and `nothing` returned.
