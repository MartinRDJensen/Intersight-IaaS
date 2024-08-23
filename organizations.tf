# Data Source for the Intersight Account
# ---- SPECIFY THE NAME OF YOUR ACCOUNT ----
data "intersight_iam_account" "account" {
    name = "ciscolab-dk"
}


#
# ---- DEFINING Resource Groups and Organizations for DC and Rentee organizations ----
#

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


resource "intersight_organization_organization" "tf_datacenter_org" {
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

resource "intersight_organization_organization" "tf_rentee_org" {
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


#
# ---- DEFINING Common Organizations ----
#

resource "intersight_organization_organization" "pools_common" {
  name = "tf-pools-common"
  account {
    object_type = "iam.Account"
    moid        = data.intersight_iam_account.account.moid
  }
}

#
# ---- DEFINING Resource Sharing ----
#

resource "intersight_iam_sharing_rule" "pools_common_to_tf_datacenter_org" {
  account {
    object_type = "iam.Account"
    moid        = data.intersight_iam_account.account.moid
  }

  shared_resource = [{
    moid        = intersight_organization_organization.pools_common.moid
    object_type = "organization.Organization"
    additional_properties = ""# not sure what this is
    class_id = "mo.MoRef"
    selector = "" #ignored when moid is set
  }]

  shared_with_resource = [
  {
    moid        = intersight_organization_organization.tf_datacenter_org.moid
    object_type = "organization.Organization"
    additional_properties = ""# not sure what this is
    class_id = "mo.MoRef"
    selector = "" #ignored when moid is set
  }]
}

resource "intersight_iam_sharing_rule" "pools_common_to_tf_rentee_org" {
  account {
    object_type = "iam.Account"
    moid        = data.intersight_iam_account.account.moid
  }

  shared_resource = [{
    moid        = intersight_organization_organization.pools_common.moid
    object_type = "organization.Organization"
    additional_properties = ""# not sure what this is
    class_id = "mo.MoRef"
    selector = "" #ignored when moid is set
  }]

  shared_with_resource = [{
    moid        = intersight_organization_organization.tf_rentee_org.moid
    object_type = "organization.Organization"
    additional_properties = ""# not sure what this is
    class_id = "mo.MoRef"
    selector = "" #ignored when moid is set
  }]
}