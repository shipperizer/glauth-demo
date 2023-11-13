GLAUTH?=glauth/v2
GO111MODULE?=on
CGO_ENABLED?=1
GOOS?=linux
GOARCH?=amd64
REPO?=localhost:32000
SKAFFOLD?=skaffold
KUBECTL?=kubectl

.EXPORT_ALL_VARIABLES:

plugin-postgres:
# TODO @shipperizer only pull postgres plugin with 
# U=https://github.com/glauth/glauth-postgres M=pkg/plugins/glauth-postgres make pull-plugin
	$(MAKE) -C $(GLAUTH) pull-base-plugins 
	$(MAKE) -C $(GLAUTH) plugin_postgres
.PHONY: plugin_postgres

build:
	$(MAKE) -C $(GLAUTH) $(GOOS)$(GOARCH)
.PHONY: build


dev:
	SKAFFOLD_DEFAULT_REPO=$(REPO) $(SKAFFOLD) run
	$(SKAFFOLD) run -p postgresql --port-forward --tail


certs-show:
	@echo copy ca.crt into /usr/local/share/ca-certificates then run update-ca-certificates
	$(KUBECTL) get secret -o yaml glauth-tls | yq '.data'
	@echo after if you point openssl or certigo to the forwarded glauth service and override 
	@echo /etc/hosts with "127.0.0.1 glauth.default.svc.cluster.local" you should be able to 
	@echo verify the certificate