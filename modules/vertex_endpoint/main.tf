resource "google_vertex_ai_endpoint" "endpoint" {
  name         = "${var.endpoint_name}-${random_id.suffix.hex}"
  display_name = var.endpoint_name
  location     = var.region
}

resource "random_id" "suffix" {
  byte_length = 2
}
