```julia
print([io::IO = stdout,] [data::Vector = fetch()], [lidict::Union{LineInfoDict, LineInfoFlatDict} = getdict(data)]; kwargs...)
print(path::String, [cols::Int = 1000], [data::Vector = fetch()], [lidict::Union{LineInfoDict, LineInfoFlatDict} = getdict(data)]; kwargs...)
```

Prints profiling results to `io` (by default, `stdout`). If you do not supply a `data` vector, the internal buffer of accumulated backtraces will be used. Paths are clickable links in supported terminals and specialized for [`JULIA_EDITOR`](@ref) with line numbers, or just file links if no editor is set.

The keyword arguments can be any combination of:

  * `format` – Determines whether backtraces are printed with (default, `:tree`) or without (`:flat`) indentation indicating tree structure.
  * `C` – If `true`, backtraces from C and Fortran code are shown (normally they are excluded).
  * `combine` – If `true` (default), instruction pointers are merged that correspond to the same line of code.
  * `maxdepth` – Limits the depth higher than `maxdepth` in the `:tree` format.
  * `sortedby` – Controls the order in `:flat` format. `:filefuncline` (default) sorts by the source  line, `:count` sorts in order of number of collected samples, and `:overhead` sorts by the number of samples  incurred by each function by itself.
  * `groupby` – Controls grouping over tasks and threads, or no grouping. Options are `:none` (default), `:thread`, `:task`,  `[:thread, :task]`, or `[:task, :thread]` where the last two provide nested grouping.
  * `noisefloor` – Limits frames that exceed the heuristic noise floor of the sample (only applies to format `:tree`).  A suggested value to try for this is 2.0 (the default is 0). This parameter hides samples for which `n <= noisefloor * √N`,  where `n` is the number of samples on this line, and `N` is the number of samples for the callee.
  * `mincount` – Limits the printout to only those lines with at least `mincount` occurrences.
  * `recur` – Controls the recursion handling in `:tree` format. `:off` (default) prints the tree as normal. `:flat` instead  compresses any recursion (by ip), showing the approximate effect of converting any self-recursion into an iterator.  `:flatc` does the same but also includes collapsing of C frames (may do odd things around `jl_apply`).
  * `threads::Union{Int,AbstractVector{Int}}` – Specify which threads to include snapshots from in the report. Note that  this does not control which threads samples are collected on (which may also have been collected on another machine).
  * `tasks::Union{Int,AbstractVector{Int}}` – Specify which tasks to include snapshots from in the report. Note that this  does not control which tasks samples are collected within.

!!! compat "Julia 1.8"
    The `groupby`, `threads`, and `tasks` keyword arguments were introduced in Julia 1.8.


!!! note
    Profiling on windows is limited to the main thread. Other threads have not been sampled and will not show in the report.

