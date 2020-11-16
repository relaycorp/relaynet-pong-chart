# Helm Chart for Relaynet Pong

This Helm chart allows you to deploy [Relaynet Pong](https://docs.relaycorp.tech/relaynet-pong/) to any Kubernetes-compatible cloud provider.

## Example

At a minimum, you have to specify the Vault authentication token; e.g.:

```
helm repo add relaycorp https://h.cfcr.io/relaycorp/public

helm install \
  --set vault.token=the-secret-token \
  pong-test \
  relaycorp/relaynet-pong
```

Check out [`example/`](./example) for a working example on Google Cloud Platform.

## Configuration options

| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `nameOverride` | string | | A custom name for the release, to override the one passed to Helm |
| `podSecurityContext` | object | `{}` | A custom `securityContext` to be attached to the pods |
| `securityContext` | object | `{}` | A custom `securityContext` to be attached to the deployments |
| `resources` | object | `{}` | A custom name `resources` to be attached to the containers |
| `service.type` | string | `ClusterIP` | The service type for the PoHTTP endpoint |
| `service.port` | number | `80` | The service port for the PoHTTP endpoint |
| `ingress.enabled` | boolean | `false` | Whether to use an ingress for the PoHTTP endpoint |
| `ingress.annotations` | object | `{}` | Annotations for the ingress |
| `redis.host` | string | `redis` | The Redis host |
| `redis.port` | number | `6379` | The Redis port |
| `vault.host` | string | `vault` | The Vault host |
| `vault.port` | number | `8200` | The Vault port |
| `vault.session_keys_mount_path` | string | `pong-keys` | The mount point for the K/V engine v2 to use |
| `vault.token` (required) | string | | The Vault authentication token |
| `http_request_id_header` | string | `X-Request-Id` | The HTTP request id header to be passed to the PoHTTP endpoint server |
| `pohttp_tls_required` | boolean | `true` | Whether the gateway receiving a pong message must use TLS |
| `current_endpoint_key_id` | string | (autogenerated) | The id for the current long-term node key pair |

## Development

Here's how to set up your local environment for development:

1. Install Redis:
   ```
   helm install --set usePassword=false redis-test stable/redis
   ```
1. Install Vault:
   ```
   helm install vault-test https://github.com/hashicorp/vault-helm/archive/v0.3.3.tar.gz
   ```
1. Configure Vault:
   1. Initialize Vault, and securely store tokens generated. Keep the tokens handy because we'll need them shortly.
      ```
      kubectl exec -it vault-test-0 -- vault operator init
      ```
   1. Temporarily store the root token generated by `vault operator init` as we'll use it later a few times. Note that you minimize the use of this token in production and use non-root authentication instead.
      ```
      VAULT_TOKEN='replace with root token'
      ```
   1. Unseal Vault by running the following command three times, entering a different unseal token each time:
      ```
      kubectl exec -it vault-test-0 -- vault operator unseal
      ```
   1. Enable the kv secret store at `pong-keys/` and make such secrets expire after 7 days:
      ```
      kubectl exec -it vault-test-0 -- vault login token=${VAULT_TOKEN}
      kubectl exec -it vault-test-0 -- vault secrets enable -path=pong-keys kv-v2
      ```
1. Finally, deploy this chart and follow the post-install instructions:
   ```
   helm install \
     --set ingress.enabled=true \
     --set redis.host=redis-test-master.default.svc.cluster.local \
     --set vault.host=vault-test.default.svc.cluster.local \
     --set vault.token=$VAULT_TOKEN \
     pong-test \
     .
   ```
