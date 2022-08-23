# Introduction

This is a great example of combining multiple tool to simplify workflow
The purpose of this script is to quickly ssh to remote server with or without
using a jump host.
List of hosts will be configure in a collection file in ini format as an
example listed below

## About peco

peco is a great filter tool that can be pipelined with multiple output types: logs, directory, grep, ...
It is such a amazing tool. Read more about peco at this awesome repo https://github.com/peco/peco

# Installation

In order to use this script, **peco** must be install

```
#macOS
brew install peco
#ubuntu
apt install peco
```

# Update host collections

Default file path is ~/.config/ssh_peco/remote_hosts
Otherwise, you can input during execution

```
[bastion_hostname]
ip=<public_ipv4>

[hostname]
ip=<private_ipv4>
bastion=<bastion_hostname>
```

# Usage

```
ssh_peco.sh <remote_hosts_collection>(optional)
```

# Example

```
# in remote_hosts
[jump-host]
ip=12.34.56.78

[private-server]
ip=10.0.0.10
bastion=jump-host

# executing
ssh_peco.sh ~/.config/ssh_peco/remote_hosts
```

# Symlink make it quicker for integration

However, this might be prone to security concerns
Do it as your own risk

Create symlink for script and remote_hosts config file

```
mkdir -p ~/.config/ssh_peco
ln -ns $(pwd)/ssh_peco.sh /usr/local/bin
ln -ns $(pwd)/remote_hosts ~/.config/ssh_peco
```
