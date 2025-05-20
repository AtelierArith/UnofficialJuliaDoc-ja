```
replace_ref_begin_end!(ex)
```

Recursively replace occurrences of the symbols `:begin` and `:end` in a "ref" expression (i.e. `A[...]`) `ex` with the appropriate function calls (`firstindex` or `lastindex`). Replacement uses the closest enclosing ref, so

```
A[B[end]]
```

should transform to

```
A[B[lastindex(B)]]
```
