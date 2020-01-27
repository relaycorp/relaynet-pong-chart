output "redis_host" {
  value = google_redis_instance.primary.host
}

resource "google_redis_instance" "primary" {
  name           = "pong-test"
  memory_size_gb = 1

  location_id = google_container_cluster.primary.location

  redis_version = "REDIS_4_0"
}
