##################################################################################
# DATA
##################################################################################

data "aws_elb_service_account" "root" {}

##S3 Bucket Policy
resource "aws_s3_bucket_policy" "web_bucket" {
  bucket = local.s3_bucket_name
  # acl           = "private"
  # force_destroy = true

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${data.aws_elb_service_account.root.arn}"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${local.s3_bucket_name}/alb-logs/*"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${local.s3_bucket_name}/alb-logs/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::${local.s3_bucket_name}"
    }
  ]
}
    POLICY

  # tags = local.common_tags

}

##S3 Bucket and contents
resource "aws_s3_object" "website" {
  for_each = {
    website = "/website/index.html"
    logo    = "/website/DevOps.png"
  }
  bucket = local.s3_bucket_name
  key    = each.value
  source = ".${each.value}"

  tags = local.common_tags
}

########################
# S3 Bucket Private Access
########################
resource "aws_s3_bucket_acl" "web_bucket_acl" {
  bucket = local.s3_bucket_name
  acl    = "private"
}