BIN := $(shell basename $$PWD)

include .mk/lb.mk
include .mk/kind.mk
include .mk/helm.mk
include .mk/help.mk

.PHONY: init load-balancer cleanup destroy

## 1. Create a cluster
cluster: kind-start


## 2. Create namespaces
namespaces:
	kubectl create ns one
	kubectl create ns two
	kubectl create ns three

## 3. Install load-balancer
load-balancer: lb-base lb-config

## 4. Install 3 ingress controllers
controllers:
	helm install ingress ingress-nginx/ingress-nginx --namespace one -f ./config/v1.yml &>/dev/null
	helm install ingress ingress-nginx/ingress-nginx --namespace two -f ./config/v2.yml &>/dev/null
	helm install ingress ingress-nginx/ingress-nginx --namespace three -f ./config/v3.yml &>/dev/null

controllers-check:
	helm list -A

controllers-undo:
	helm uninstall ingress --namespace one
	helm uninstall ingress --namespace two
	helm uninstall ingress --namespace three

## 5. Create 3 ingress objects
ingresses:
	for ns in one two three ; do \
		kubectl create deploy test --image nginx --namespace $$ns ; \
		kubectl expose deploy test --port=80 --namespace $$ns ; \
		kubectl apply -f ./config/ingress.yml --namespace $$ns ; \
	done

ingresses-check:
	kubectl get ingress -A

ingresses-undo:
	for ns in one two three ; do \
		kubectl delete -f ./config/ingress.yml --namespace $$ns ; \
		kubectl delete svc test --namespace $$ns ; \
		kubectl delete deploy test --namespace $$ns ; \
	done

## 6. Cleanup ingresses and controllers
cleanup: ingresses-undo controllers-undo

## 6. Destroy kind cluster
destroy: kind-stop
