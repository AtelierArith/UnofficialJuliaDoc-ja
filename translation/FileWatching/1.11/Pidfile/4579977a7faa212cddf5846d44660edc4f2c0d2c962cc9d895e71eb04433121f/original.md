```
mkpidlock([f::Function], at::String, [pid::Cint]; kwopts...)
mkpidlock(at::String, proc::Process; kwopts...)
```

Create a pidfile lock for the path "at" for the current process or the process identified by pid or proc. Can take a function to execute once locked, for usage in `do` blocks, after which the lock will be automatically closed. If the lock fails and `wait` is false, then an error is thrown.

The lock will be released by either `close`, a `finalizer`, or shortly after `proc` exits. Make sure the return value is live through the end of the critical section of your program, so the `finalizer` does not reclaim it early.

Optional keyword arguments:

  * `mode`: file access mode (modified by the process umask). Defaults to world-readable.
  * `poll_interval`: Specify the maximum time to between attempts (if `watch_file` doesn't work)
  * `stale_age`: Delete an existing pidfile (ignoring the lock) if it is older than this many seconds, based on its mtime.   The file won't be deleted until 5x longer than this if the pid in the file appears that it may be valid.   Or 25x longer if `refresh` is overridden to 0 to disable lock refreshing.   By default this is disabled (`stale_age` = 0), but a typical recommended value would be about 3-5x an   estimated normal completion time.
  * `refresh`: Keeps a lock from becoming stale by updating the mtime every interval of time that passes.   By default, this is set to `stale_age/2`, which is the recommended value.
  * `wait`: If true, block until we get the lock, if false, raise error if lock fails.
