resource "google_workbench_instance" "workbench" {
  name     = var.instance_name
  location = var.location

  gce_setup {
    machine_type = var.machine_type
    disable_public_ip = false

    boot_disk {
      disk_type = "pd-standard"
      disk_size_gb = 100
    }

    metadata = {
      "proxy-mode" = "service_account"
    }
  }
  # Set the VM image as you wish, or leave for default
}
