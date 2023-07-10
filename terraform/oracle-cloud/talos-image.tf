resource "oci_objectstorage_object" "talos_image-store" {
  namespace           = data.oci_objectstorage_namespace.ns.namespace
  bucket              = oci_objectstorage_bucket.byoi.name
  content             = file("https://github.com/siderolabs/talos/releases/download/v1.4.6/oracle-arm64.qcow2.xz")
  storage_tier        = "InfrequentAccess"
  opc_sse_kms_key_id  = var.kms_key_ocid
}

resource "oci_core_image" "tslos_image" {
    #Required
    compartment_id = var.compartment_id

    #Optional
    display_name = "Talos Linux 1.4.6"
    launch_mode = "NATIVE"

    image_source_details {
        source_type = "objectStorageTuple"
        bucket_name = var.bucket_name
        namespace_name = var.namespace
        object_name = var.object_name

        operating_system = "Talos Linux"
        operating_system_version = "1.4.6"
        source_image_type = "QCOW2"
    }
}
