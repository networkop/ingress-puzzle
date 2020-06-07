# Ingress Puzzle

Imagine you have a Kubernetes cluster with three namespaces, each with its own namespace-scoped ingress controller. You've created an ingress in each namespace that exposes a simple web application. You've checked one of them, made sure it works and moved on to other things. However some time later, you get reports that the web app is unavailable. You go to check it again and indeed, the page is not responding, although nothing has changed in the cluster. In fact, you realise the the problem is intermittent - one minute you can access the page, and on the next refresh it's gone. To make things worse, you realise that similar issues affect the other two ingresses. What can it be?

## Rules

* Follow the steps in the walkthrought to setup a local lab environment.
* Do not look into files in the `./config` directory unless you're out of options.
* Try to solve the puzzle just by using `kubectl` command, do not use `helm`.

## Walkthrough

1. Build a local test k8s cluster.

```
make cluster
```

2. Create three namespaces.

```
make namespaces
```

3. Create an in-cluster load-balancer (MetalLB) that will allocate IPs from a 100.64.0.0/16 range.

```
make load-balancer
```

4. In each namespace, install a namespace-scoped ingress controller.


```
make controllers
```

5. Create a test deployment and expose it via an ingress.

```
make ingresses
```

6. Solve the mystery of misbehaving ingresses.

## Cleanup

To cleanup all puzzle-related state installed in the cluster do:

```
make cleanup
```

The state can be recreated with the following commands:

```
make controllers && make ingresses
```

To destroy all state, including the test k8s cluster do:

```
make destroy
```
