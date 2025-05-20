```
isdispatchtuple(T)
```

Determine whether type `T` is a tuple "leaf type", meaning it could appear as a type signature in dispatch and has no subtypes (or supertypes) which could appear in a call. If `T` is not a type, then return `false`.
