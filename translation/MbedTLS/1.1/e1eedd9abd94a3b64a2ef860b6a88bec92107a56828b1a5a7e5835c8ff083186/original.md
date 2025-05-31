```
readavailable(ctx::SSLContext)
```

Read available decrypted data from `ctx`, but don't wait for more data to arrive.

The amount of decrypted data that can be read at once is limited by `MBEDTLS_SSL_MAX_CONTENT_LEN`.
