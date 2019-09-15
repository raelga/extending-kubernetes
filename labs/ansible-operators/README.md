# Ansible operators

## Operator SDK CLI setup

You need to go to official [DOC](https://github.com/operator-framework/operator-sdk/blob/master/doc/ansible/user-guide.md), in order to setup minimal `operator-sdk` prerequisites:

- [docker][docker_tool] version 17.03+.
- [kubectl][kubectl_tool] version v1.9.0+
- [oc][oc_tool] version v3.11+
- [ansible][ansible_tool] version v2.6.0+
- [ansible-runner][ansible_runner_tool] version v1.1.0+
- [ansible-runner-http][ansible_runner_http_plugin] version v1.0.0+
- [dep][dep_tool] version v0.5.0+. (Optional if you aren't installing from source)
- [go][go_tool] version v1.12+. (Optional if you aren't installing from source)
- Access to a Kubernetes v1.9.0+ cluster

Or if you prefer to not install anything, you can directly download operator-sdk [binary](https://github.com/operator-framework/operator-sdk/releases/download/v0.10.0/operator-sdk-v0.10.0-x86_64-linux-gnu)

## Create a new project

Use the CLI to create a new Ansible-based hello-world project:

```
$ operator-sdk new hello-world-operator --api-version=ansible-hello-world.operator.com/v1alpha1 --kind=AnsibleHelloWorld --type=ansible
$ tree hello-world-operator/
hello-world-operator/
├── build
│   ├── Dockerfile
│   └── test-framework
│       ├── ansible-test.sh
│       └── Dockerfile
├── deploy
│   ├── crds
│   │   ├── ansiblehelloworld_v1alpha1_ansiblehelloworld_crd.yaml
│   │   └── ansiblehelloworld_v1alpha1_ansiblehelloworld_cr.yaml
│   ├── operator.yaml
│   ├── role_binding.yaml
│   ├── role.yaml
│   └── service_account.yaml
├── molecule
│   ├── default
│   │   ├── asserts.yml
│   │   ├── molecule.yml
│   │   ├── playbook.yml
│   │   └── prepare.yml
│   ├── test-cluster
│   │   ├── molecule.yml
│   │   └── playbook.yml
│   └── test-local
│       ├── molecule.yml
│       ├── playbook.yml
│       └── prepare.yml
├── roles
│   └── ansiblehelloworld
│       ├── defaults
│       │   └── main.yml
│       ├── files
│       ├── handlers
│       │   └── main.yml
│       ├── meta
│       │   └── main.yml
│       ├── README.md
│       ├── tasks
│       │   └── main.yml
│       ├── templates
│       └── vars
│           └── main.yml
└── watches.yaml

17 directories, 25 files
```

[operator-sdk]:https://github.com/operator-framework/operator-sdk
[docker_tool]:https://docs.docker.com/install/
[ansible_tool]:https://docs.ansible.com/ansible/latest/index.html
[ansible_runner_tool]:https://ansible-runner.readthedocs.io/en/latest/install.html
[ansible_runner_http_plugin]:https://github.com/ansible/ansible-runner-http
[dep_tool]:https://golang.github.io/dep/docs/installation.html
[go_tool]:https://golang.org/
[kubernetes]:https://kubernetes.io/
[kubectl_tool]:https://kubernetes.io/docs/tasks/tools/install-kubectl/
[oc_tool]:https://docs.okd.io/3.11/cli_reference/get_started_cli.html#cli-reference-get-started-cli
