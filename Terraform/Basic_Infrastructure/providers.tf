# While providing version numbers The following operators are valid:

# = (or no operator): Allows only one exact version number. Cannot be combined with other conditions.

# !=: Excludes an exact version number.

# >, >=, <, <=: Comparisons against a specified version, allowing versions for which the comparison is true. "Greater-than" requests newer versions, and "less-than" requests older versions.

# ~>: Allows only the rightmost version component to increment. 
# For example, to allow new patch releases within a specific minor release, use the full version number: ~> 1.0.4 will allow installation of 1.0.5 and 1.0.10 but not 1.1.0. This is usually called the pessimistic constraint operator.

terraform {
  required_version = "1.3.6" # this is the terraform version to be used , we are forcing to use this
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0" # this is the aws version to be used 
    }
  }
}