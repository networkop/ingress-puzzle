# KIND cluster name
KIND_CLUSTER_NAME ?= $(BIN)
export KUBECONFIG=kubeconfig

ifeq (,$(wildcard ./kind.yaml))
KIND_CONF :=  
else
KIND_CONF := --config ./config/kind.yaml
endif


kind-install: 
	GO111MODULE="on" go get -u sigs.k8s.io/kind@v0.7.0


kind-stop: 
	@kind delete cluster --name $(KIND_CLUSTER_NAME) || \
		echo "kind cluster is not running"


kind-ensure: 
	@which kind >/dev/null 2>&1 || \
		make kind-install


kind-start: kind-ensure 
	@kind get clusters | grep $(KIND_CLUSTER_NAME)  >/dev/null 2>&1 || \
		kind create cluster --name $(KIND_CLUSTER_NAME) --kubeconfig kubeconfig $(KIND_CONF)


kind-load: kind-ensure 
	kind load docker-image --name $(KIND_CLUSTER_NAME) ${IMG}



