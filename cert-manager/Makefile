setup:
	kubectl apply -f namespace.yml
	helm repo add jetstack https://charts.jetstack.io
	helm repo update
	kubectl label namespace ingress-basic cert-manager.io/disable-validation=true

install:
	helm install \
		cert-manager \
		--namespace ingress-basic \
		--set installCRDs=true \
		--set nodeSelector."beta\.kubernetes\.io/os"=linux \
		jetstack/cert-manager

apply-issuers:
	kubectl apply -n ingress-basic -f issuer-prod.yml -f issuer-staging.yml

uninstall:
	helm uninstall cert-manager \
		--namespace ingress-basic
