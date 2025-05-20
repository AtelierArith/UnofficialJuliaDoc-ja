```
credential_callback(...) -> Cint
```

A LibGit2 credential callback function which provides different credential acquisition functionality w.r.t. a connection protocol. The `payload_ptr` is required to contain a `LibGit2.CredentialPayload` object which will keep track of state and settings.

The `allowed_types` contains a bitmask of `LibGit2.Consts.GIT_CREDTYPE` values specifying which authentication methods should be attempted.

Credential authentication is done in the following order (if supported):

  * SSH agent
  * SSH private/public key pair
  * Username/password plain text

If a user is presented with a credential prompt they can abort the prompt by typing `^D` (pressing the control key together with the `d` key).

**Note**: Due to the specifics of the `libgit2` authentication procedure, when authentication fails, this function is called again without any indication whether authentication was successful or not. To avoid an infinite loop from repeatedly using the same faulty credentials, we will keep track of state using the payload.

For addition details see the LibGit2 guide on [authenticating against a server](https://libgit2.org/docs/guides/authentication/).
