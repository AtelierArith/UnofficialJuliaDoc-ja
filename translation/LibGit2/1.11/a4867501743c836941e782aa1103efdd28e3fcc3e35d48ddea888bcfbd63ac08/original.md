```julia
LibGit2.MergeOptions
```

Matches the [`git_merge_options`](https://libgit2.org/libgit2/#HEAD/type/git_merge_options) struct.

The fields represent:

  * `version`: version of the struct in use, in case this changes later. For now, always `1`.
  * `flags`: an `enum` for flags describing merge behavior.  Defined in [`git_merge_flag_t`](https://github.com/libgit2/libgit2/blob/HEAD/include/git2/merge.h#L95).  The corresponding Julia enum is `GIT_MERGE` and has values:

      * `MERGE_FIND_RENAMES`: detect if a file has been renamed between the common ancestor and the "ours" or "theirs" side of the merge. Allows merges where a file has been renamed.
      * `MERGE_FAIL_ON_CONFLICT`: exit immediately if a conflict is found rather than trying to resolve it.
      * `MERGE_SKIP_REUC`: do not write the REUC extension on the index resulting from the merge.
      * `MERGE_NO_RECURSIVE`: if the commits being merged have multiple merge bases, use the first one, rather than trying to recursively merge the bases.
  * `rename_threshold`: how similar two files must to consider one a rename of the other. This is an integer that sets the percentage similarity. The default is 50.
  * `target_limit`: the maximum number of files to compare with to look for renames. The default is 200.
  * `metric`: optional custom function to use to determine the similarity between two files for rename detection.
  * `recursion_limit`: the upper limit on the number of merges of common ancestors to perform to try to build a new virtual merge base for the merge. The default is no limit. This field is only present on libgit2 versions newer than 0.24.0.
  * `default_driver`: the merge driver to use if both sides have changed. This field is only present on libgit2 versions newer than 0.25.0.
  * `file_favor`: how to handle conflicting file contents for the `text` driver.

      * `MERGE_FILE_FAVOR_NORMAL`: if both sides of the merge have changes to a section,  make a note of the conflict in the index which `git checkout` will use to create  a merge file, which the user can then reference to resolve the conflicts. This is  the default.
      * `MERGE_FILE_FAVOR_OURS`: if both sides of the merge have changes to a section,  use the version in the "ours" side of the merge in the index.
      * `MERGE_FILE_FAVOR_THEIRS`: if both sides of the merge have changes to a section,  use the version in the "theirs" side of the merge in the index.
      * `MERGE_FILE_FAVOR_UNION`: if both sides of the merge have changes to a section,  include each unique line from both sides in the file which is put into the index.
  * `file_flags`: guidelines for merging files.
