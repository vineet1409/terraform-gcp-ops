
resource "google_notebooks_instance" "workbench" {
  name         = var.instance_name
  location     = var.location
  machine_type = var.machine_type

  vm_image {
    project      = "deeplearning-platform-release"
    image_family = "tf2-ent-2-8-cpu"
  }
}
