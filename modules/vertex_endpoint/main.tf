
resource "google_vertex_ai_endpoint" "endpoint" {
  display_name = var.endpoint_name
  location     = var.region
}
