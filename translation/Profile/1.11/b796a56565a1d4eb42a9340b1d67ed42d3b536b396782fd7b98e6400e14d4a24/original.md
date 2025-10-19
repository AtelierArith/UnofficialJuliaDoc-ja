```julia
Profile.take_heap_snapshot(filepath::String, all_one::Bool=false;
                           redact_data::Bool=true, streaming::Bool=false)
Profile.take_heap_snapshot(all_one::Bool=false; redact_data:Bool=true,
                           dir::String=nothing, streaming::Bool=false)
```

Write a snapshot of the heap, in the JSON format expected by the Chrome Devtools Heap Snapshot viewer (.heapsnapshot extension) to a file (`$pid_$timestamp.heapsnapshot`) in the current directory by default (or tempdir if the current directory is unwritable), or in `dir` if given, or the given full file path, or IO stream.

If `all_one` is true, then report the size of every object as one so they can be easily counted. Otherwise, report the actual size.

If `redact_data` is true (default), then do not emit the contents of any object.

If `streaming` is true, we will stream the snapshot data out into four files, using filepath as the prefix, to avoid having to hold the entire snapshot in memory. This option should be used for any setting where your memory is constrained. These files can then be reassembled by calling Profile.HeapSnapshot.assemble_snapshot(), which can be done offline.

NOTE: We strongly recommend setting streaming=true for performance reasons. Reconstructing the snapshot from the parts requires holding the entire snapshot in memory, so if the snapshot is large, you can run out of memory while processing it. Streaming allows you to reconstruct the snapshot offline, after your workload is done running. If you do attempt to collect a snapshot with streaming=false (the default, for backwards-compatibility) and your process is killed, note that this will always save the parts in the same directory as your provided filepath, so you can still reconstruct the snapshot after the fact, via `assemble_snapshot()`.
