netchecker-agent
================

Basic network checker agent to check DNS and connectivity in kubernetes
cluster. Should be used together with [netchecker-server]
(https://github.com/adidenko/netchecker-server).

Agent runs on all k8s minions (controll this with label) and periodically reports
some info to `netchecker-service`. If all agents are able to report, then your
k8s network setup and DNS service are fine.

How to
------

* Build and push container:

```bash
cd ./docker && cat README.md
```

* Label nodes for running netchecker agent:

```bash
# Label all nodes
kubectl get nodes | grep Ready | awk '{print $1}' | xargs -I {} kubectl label nodes {} netchecker=agent
```

* Run netchecker agents:

```bash
kubectl create -f netchecker-agent.yaml
```
