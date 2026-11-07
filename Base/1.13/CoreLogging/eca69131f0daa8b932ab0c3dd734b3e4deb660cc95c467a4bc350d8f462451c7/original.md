```julia
disable_logging(level)
```

Disable all log messages at log levels equal to or less than `level`.  This is a *global* setting, intended to make debug logging extremely cheap when disabled. Note that this cannot be used to enable logging that is currently disabled by other mechanisms.

# Examples

```julia
Logging.disable_logging(Logging.Info) # Disable debug and info
```
