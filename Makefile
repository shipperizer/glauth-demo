GLAUTH?=glauth/v2
GO111MODULE?=on
CGO_ENABLED?=1
GOOS?=linux
GOARCH?=amd64

.EXPORT_ALL_VARIABLES:

plugin-postgres:
# TODO @shipperizer only pull postgres plugin with 
# U=https://github.com/glauth/glauth-postgres M=pkg/plugins/glauth-postgres make pull-plugin
	$(MAKE) -C $(GLAUTH) pull-base-plugins 
	$(MAKE) -C $(GLAUTH) plugin_postgres
.PHONY: plugin_postgres

build: plugin-postgres
	$(MAKE) -C $(GLAUTH) $(GOOS)$(GOARCH)
.PHONY: build
