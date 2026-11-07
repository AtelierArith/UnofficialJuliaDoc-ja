```julia
GitDiff(content::AbstractString)
```

バッファから差分を解析します。`content`は統一 diff 形式である必要があります。[`GitDiff`](@ref)オブジェクトを返します。

これは[`git_diff_from_buffer`](https://libgit2.org/libgit2/#HEAD/group/diff/git_diff_from_buffer)と同等です。

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
