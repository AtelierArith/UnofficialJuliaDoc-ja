```
GitShortHash(obj::GitObject)
```

Get a shortened identifier (`GitShortHash`) of `obj`. The minimum length (in characters) is determined by the `core.abbrev` config option, and will be of sufficient length to unambiguously identify the object in the repository.
