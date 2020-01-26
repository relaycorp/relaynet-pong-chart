# relaynet-pong-chart
Helm v3 chart for Relaynet Pong

## Testing

```
helm install --set usePassword=false redis-test stable/redis

helm install vault-test https://github.com/hashicorp/vault-helm/archive/v0.3.3.tar.gz

kubectl exec -it vault-test-0 -- vault operator init
# Get 3 of the 5 unseal tokens above and paste one at a time when runnning `vault operator unseal`
kubectl exec -it vault-test-0 -- vault operator unseal
kubectl exec -it vault-test-0 -- vault operator unseal
kubectl exec -it vault-test-0 -- vault operator unseal

VAULT_TOKEN='s.the-secret-token'

kubectl exec -it vault-test-0 -- vault login token=${VAULT_TOKEN}

kubectl exec -it vault-test-0 -- vault secrets enable -path=pong-keys kv-v2

helm install --values ci/required-values.yml --set redis.host=redis-test-master.default.svc.cluster.local,vault.host=vault-test.default.svc.cluster.local pong-test .
```
