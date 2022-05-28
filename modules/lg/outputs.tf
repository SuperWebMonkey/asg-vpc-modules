output "aws_key_id" {
    value = "${aws_key_pair.my_aws_key.id}"
}

output "launch_config_id" {
    value = "${aws_launch_configuration.as_conf.id}"
}