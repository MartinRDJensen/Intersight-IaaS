# Data Source for the Intersight Account
# ---- SPECIFY THE NAME OF YOUR ACCOUNT ----
data "intersight_iam_account" "account" {
    name = "ciscolab-dk"
}

resource "intersight_resource_group" "dc_rg" {
  name        = "tf-all-hardware-rg"
  description = "Resource group for all data center hardware. Will belong to tf-datacenter-org"

  account {
    object_type = "iam.Account"
    moid        = data.intersight_iam_account.account.moid
  }

  qualifier = "Allow-All"

}

resource "intersight_resource_group" "rentee_rg" {
  name        = "tf-rentee-hardware"
  description = "Resource group for rentees. Will belong to tf-rentee-org"

  account {
    object_type = "iam.Account"
    moid        = data.intersight_iam_account.account.moid
  }
}


resource "intersight_organization_organization" "tf-datacenter-org" {
  name = "tf-datacenter-org"
  account {
    object_type = "iam.Account"
    moid        = data.intersight_iam_account.account.moid
  }
  resource_groups {
    moid        = intersight_resource_group.dc_rg.moid
    object_type = "resource.Group"
    class_id    = "resource.Group"
  }
}

resource "intersight_organization_organization" "tf-rentee-org" {
  name = "tf-rentee-org"
  account {
    object_type = "iam.Account"
    moid        = data.intersight_iam_account.account.moid
  }
  resource_groups {
    moid        = intersight_resource_group.rentee_rg.moid
    object_type = "resource.Group"
    class_id    = "resource.Group"
  }
}

