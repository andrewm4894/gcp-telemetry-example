########################################
## compose_telemetry_events
########################################

/*
compose_telemetry_events
*/

resource "google_pubsub_topic" "compose_telemetry_events" {
  name = "compose_telemetry_events"
}