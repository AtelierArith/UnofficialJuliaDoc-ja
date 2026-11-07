```julia
LibGit2.Buffer
```

A data buffer for exporting data from libgit2. Matches the [`git_buf`](https://libgit2.org/libgit2/#HEAD/type/git_buf) struct.

When fetching data from LibGit2, a typical usage would look like:

```julia
buf_ref = Ref(Buffer())
@check ccall(..., (Ptr{Buffer},), buf_ref)
# operation on buf_ref
free(buf_ref)
```

In particular, note that `LibGit2.free` should be called afterward on the `Ref` object.
