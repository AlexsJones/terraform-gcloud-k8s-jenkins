resource "google_container_cluster" "cluster" {
  name               = "${var.cluster-name}"
  zone               = "${var.gcloud-zone}"
  initial_node_count = "${var.cluster-size}"

  master_auth {
    username = "${var.username}"
    password = "${var.password}"
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    machine_type = "${var.machine-type}"
  }

  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${var.cluster-name} --zone ${var.gcloud-zone} --project ${var.gcloud-project}"
  }

  provisioner "local-exec" {
    command = "kubectl cluster-info"
  }

  provisioner "local-exec" {
    command = "kubectl create secret generic jenkins --from-file=deployments/jenkins/options --namespace=default"
  }

  /*
  provisioner "local-exec" {
    command = "gcloud compute images create jenkins-home-image --source-uri https://storage.googleapis.com/solutions-public-assets/jenkins-cd/jenkins-home-v3.tar.gz"
  }

  provisioner "local-exec" {
    command = "gcloud compute disks create jenkins-home --image jenkins-home-image --zone=${var.gcloud-zone}"
  }*/
}
