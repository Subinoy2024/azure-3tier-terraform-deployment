variable "resource_groups" {
  description = "Map of resource groups"
  type = map(object({
    location = string
    tags     = map(string)
  }))
}
