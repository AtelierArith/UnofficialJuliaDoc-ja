```
disable_logging(level)
```

Disable all log messages at log levels equal to or less than `level`.  This is a *global* setting, intended to make debug logging extremely cheap when disabled.

# Examples

```julia
Logging.disable_logging(Logging.Info) # Disable debug and info
```
