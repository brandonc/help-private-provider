provider "tfe" {
  hostname = "app.staging.terraform.io"
  organization = "foo"
}

resource "tfe_registry_gpg_key" "foo" {
  ascii_armor = file("my_key.pgp")
}

output "key_id" {
  value = tfe_registry_gpg_key.foo.id
}
