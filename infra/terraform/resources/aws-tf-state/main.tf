resource "aws_s3_bucket" "tf_state_bucket" {
  bucket = "tf-state-talks"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    app = "terraform"
    account = "talks"
  }
}

resource "aws_dynamodb_table" "tf_state_lock_table" {
  name           = "tf-state-talks-locks"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1

  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    app = "terraform"
    account = "talks"
  }
}
