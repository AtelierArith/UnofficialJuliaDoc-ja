```julia
shred!(s::SecretBuffer)
```

Shreds the contents of a `SecretBuffer` by securely zeroing its data and resetting its pointer and size. This function is used to securely erase the sensitive data held in the buffer, reducing the potential for information leaks.

# Examples

```julia
s = SecretBuffer()
write(s, 's', 'e', 'c', 'r', 'e', 't')
shred!(s)  # s is now empty
```
