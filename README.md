# Ansible with AWS CLI v2

Ansible and AWS cli inside Docker for consistent running of ansible inside your local machine or CI/CD system.

## Original Work

Thank you for [Will Hall](https://www.willhallonline.co.uk) for his original repository [docker-ansible](https://github.com/willhallonline/docker-ansible).

## Running

**You will likely need to mount required directories into your container to make it run (or build on top of what is here).

### Simple

```bash
docker run --rm -it ghcr.io/atefhaloui/ansible-aws:latest /bin/sh
```

### Mount local directory and ssh key

```bash
docker run --rm -it -v $(pwd):/ansible -v ~/.ssh/id_rsa:/root/id_rsa ghcr.io/atefhaloui/ansible-aws:latest /bin/sh
```

### Injecting commands

```bash
docker run --rm -it -v $(pwd):/ansible -v ~/.ssh/id_rsa:/root/id_rsa ghcr.io/atefhaloui/ansible-aws:latest ansible-playbook playbook.yml
```

### Bash Alias

You can put these inside your dotfiles (~/.bashrc or ~/.zshrc to make handy aliases).

```bash
alias docker-ansible-cli='docker run --rm -it -v $(pwd):/ansible -v ~/.ssh/id_rsa:/root/.ssh/id_rsa --workdir=/ansible ghcr.io/atefhaloui/ansible-aws:latest /bin/sh'
alias docker-ansible-cmd='docker run --rm -it -v $(pwd):/ansible -v ~/.ssh/id_rsa:/root/.ssh/id_rsa --workdir=/ansible ghcr.io/atefhaloui/ansible-aws:latest '
```

use with:

```bash
docker-ansible-cli ansible-playbook -u playbook.yml
```

To accelerate using Mitogen look into [Using Mitogen](docs/using-mitogen.md).
