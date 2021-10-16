resource "helm_release" "apiserver" {
  name       = "apiserver"
  chart      = "./helm-chart/apiserver"

  set {
    name = "image.tag"
    value = var.image_tag
  }
}