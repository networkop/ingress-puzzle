# Helm-specific targets

helm-install: 
	curl -LO https://get.helm.sh/helm-v3.2.2-linux-amd64.tar.gz
	tar zxvf helm-v3.2.2-linux-amd64.tar.gz 
	mv linux-amd64/helm ~/go/bin/
	chmod +x ~/go/bin/helm 
	rm -rf linux-amd64
	rm -rf helm-v3.2.2-linux-amd64.tar.gz

helm-stop: 
	@helm delete cluster --name $(helm_CLUSTER_NAME) || \
		echo "helm cluster is not running"


helm-ensure: 
	@which helm >/dev/null 2>&1 || \
		make helm-install


helm-init: helm-ensure 
	helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx


