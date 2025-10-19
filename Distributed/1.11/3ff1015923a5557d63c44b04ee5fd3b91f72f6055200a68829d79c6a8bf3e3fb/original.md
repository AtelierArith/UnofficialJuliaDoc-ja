```julia
RemoteException(captured)
```

Exceptions on remote computations are captured and rethrown locally.  A `RemoteException` wraps the `pid` of the worker and a captured exception. A `CapturedException` captures the remote exception and a serializable form of the call stack when the exception was raised.
