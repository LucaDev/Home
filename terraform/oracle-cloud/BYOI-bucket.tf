resource "oci_objectstorage_bucket" "bucket1" {
  compartment_id = var.compartment_ocid
  namespace      = data.oci_objectstorage_namespace.ns.namespace
  name           = "BYOI"
  access_type    = "NoPublicAccess"
  auto_tiering   = "Disabled"
}
