
lb-base:
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
	kubectl -n metallb-system get secret memberlist &>/dev/null \
	|| kubectl -n metallb-system create secret generic memberlist --from-literal=secretkey="$$(openssl rand -base64 128)"

lb-config:
	kubectl apply -f ./config/metallb-config.yaml