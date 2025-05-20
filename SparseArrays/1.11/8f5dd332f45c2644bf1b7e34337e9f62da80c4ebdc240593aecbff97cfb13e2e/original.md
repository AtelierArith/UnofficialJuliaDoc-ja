```
allowscalar(::Bool)
```

An experimental function that allows one to disable and re-enable scalar indexing for sparse matrices and vectors.

`allowscalar(false)` will disable scalar indexing for sparse matrices and vectors. `allowscalar(true)` will restore the original scalar indexing functionality.

Since this function overwrites existing definitions, it will lead to recompilation. It is useful mainly when testing code for devices such as [GPUs](https://cuda.juliagpu.org/stable/usage/workflow/), where the presence of scalar indexing can lead to substantial slowdowns. Disabling scalar indexing during such tests can help identify performance bottlenecks quickly.
