```julia
GitDiff(content::AbstractString)
```

Parse a diff from a buffer. The `content` should be in unified diff format. Returns a [`GitDiff`](@ref) object.

This is equivalent to [`git_diff_from_buffer`](https://libgit2.org/libgit2/#HEAD/group/diff/git_diff_from_buffer).

# Examples

```julia
diff_str = """
diff --git a/file.txt b/file.txt
index 1234567..abcdefg 100644
--- a/file.txt
+++ b/file.txt
@@ -1 +1 @@
-old content
+new content
"""
diff = LibGit2.GitDiff(diff_str)
```
