In this post we will show you how to create a ssh-key and how to upload it correctly to your server.

### 1. Creating SSH-key

- To generate an SSH-key, enter the following command on the "home" terminal:
```bash
ssh-keygen -t rsa -b 4096
```

1. -t stands for type and this determines the type of key
2. -b stands for bits. This can be used to determine the length of the key.

### 2. Safing the SSH-key

```bash
Generating public rsa key pair.
Enter file in which to save the key (/home/me/.ssh/id_rsa):
```

- Here you can select a different location and an alternative name for the file containing the private key. Just press "Enter" to accept the given suggestion.

```bash
Enter passphrase (empty for no passphrase):
```

- Optionally, a password for the public key can be assigned here. This is always queried when the public key file is used to establish a connection.

```bash
Enter same passphrase again:
```

- Enter the same password again. If the field is empty, simply press "Enter"

### 3. Copying the SSH-key on your server

```bash
ssh-copy-id me@myrootserver.de
```

- Copy the public key to the desired server. For this the password of the server is necessary.
- NOTE: this will only work if the public key lays on the default location

### 4. Login without password

Now, if all of the steps are done right you´ll be able to login over ssh without your password.
Simply connect over ssh:

```bash
ssh user@myrootserver.de
```
### For permanent avoid password promt and use ssh-agent instead add:

1.
* for ZSH, the following into your `~/.zshrc`

```
ssh-agent zsh
```

* for Bash the following into your `~/.bashrc`

```
ssh-agent bash
```

2. issue the following Command
```
ssh-add ~/.ssh/id_rsa
```
