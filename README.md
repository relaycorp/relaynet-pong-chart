# relaynet-pong-chart
Helm v3 chart for Relaynet Pong

## Testing

```
helm install --set usePassword=false redis-test stable/redis
helm install vault-test https://github.com/hashicorp/vault-helm/archive/v0.3.3.tar.gz

helm install --values ci/required-values.yml --set redis.host=redis-test-master.default.svc.cluster.local,vault.address=vault-test.default.svc.cluster.local pong-test .
```
