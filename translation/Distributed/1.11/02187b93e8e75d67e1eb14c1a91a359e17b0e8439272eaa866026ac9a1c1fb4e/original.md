```
ProcessExitedException(worker_id::Int)
```

After a client Julia process has exited, further attempts to reference the dead child will throw this exception.
