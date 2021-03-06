setup:
	helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

# Install nginx ingress controller
# The configurable parameters are explained on https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-helm/
# The last two lines should be commented out when controller is installed first time.
# The last two lines will be uncommented later when metrics for prometheus are activated.
install:
ifndef STATIC_IP
	$(error STATIC_IP is undefined)
endif
ifndef DNS_LABEL
	$(error DNS_LABEL is undefined)
endif
	helm upgrade --install nginx-ingress ingress-nginx/ingress-nginx \
		--namespace ingress-basic --create-namespace \
		--set controller.replicaCount=2 \
		--set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
		--set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux \
		--set controller.admissionWebhooks.patch.nodeSelector."beta\.kubernetes\.io/os"=linux \
		--set controller.service.loadBalancerIP="$(STATIC_IP)" \
		--set controller.service.annotations."service\.beta\.kubernetes\.io/azure-dns-label-name"="$(DNS_LABEL)" \
		#--set controller.metrics.enabled=true \
		#--set controller.metrics.serviceMonitor.enabled=true


webingress:
	kubectl apply -f ingress-nginx-tls.yml

webservers:
	kubectl apply -f webservers.yml


uninstall:
	helm uninstall nginx-ingress \
		--namespace ingress-basic

status:
	kubectl describe -n ingress-basic svc nginx-ingress-ingress-nginx-controller
