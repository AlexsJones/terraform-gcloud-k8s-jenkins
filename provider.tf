provider "google" {
  credentials = "${file("account.json")}"
  project     = "${var.gcloud-project}"
  region      = "${var.gcloud-region}"
}
