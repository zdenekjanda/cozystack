NAME=platform
NAMESPACE=cozy-system

API_VERSIONS_FLAGS=$(addprefix -a ,$(shell kubectl api-versions))

show:
	helm template -n $(NAMESPACE) $(NAME) . --dry-run=server $(API_VERSIONS_FLAGS)

apply:
	@echo "Applying active HelmReleases..."
	helm template -n $(NAMESPACE) $(NAME) . --dry-run=server $(API_VERSIONS_FLAGS) \
		| yq 'select(.metadata.annotations."cozystack.io/marked-for-deletion" != "true")' - \
		| kubectl apply -f-

delete:
	@echo "Deleting marked-for-deletion HelmReleases..."
	helm template -n $(NAMESPACE) $(NAME) . --dry-run=server $(API_VERSIONS_FLAGS) \
		| yq 'select(.metadata.annotations."cozystack.io/marked-for-deletion" == "true")' -  \
		| kubectl delete -f - --ignore-not-found=true

reconcile: apply delete

namespaces-show:
	helm template -n $(NAMESPACE) $(NAME) . --dry-run=server $(API_VERSIONS_FLAGS) -s templates/namespaces.yaml

namespaces-apply:
	helm template -n $(NAMESPACE) $(NAME) . --dry-run=server $(API_VERSIONS_FLAGS) -s templates/namespaces.yaml | kubectl apply -n $(NAMESPACE) -f-

diff:
	helm template -n $(NAMESPACE) $(NAME) . --dry-run=server $(API_VERSIONS_FLAGS) | kubectl diff -f-
