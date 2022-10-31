output "service_ip" {

  value = length(module.ec2) > 0 ? module.ec2[0].instance_public_ip : "127.0.0.1"

}