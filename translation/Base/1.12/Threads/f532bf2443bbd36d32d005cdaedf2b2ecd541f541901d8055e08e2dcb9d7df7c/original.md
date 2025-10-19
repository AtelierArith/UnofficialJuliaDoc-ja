Special note for [`Threads.Condition`](@ref):

The caller must be holding the [`lock`](@ref) that owns a `Threads.Condition` before calling this method. The calling task will be blocked until some other task wakes it, usually by calling [`notify`](@ref) on the same `Threads.Condition` object. The lock will be atomically released when blocking (even if it was locked recursively), and will be reacquired before returning.
