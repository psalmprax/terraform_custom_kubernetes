##output "kubernetes_master_output" {
##  value = "${aws_instance.kubernetes_master.execution_results[0].stdout}"
##}
#
#
##output "kubernetes_master_output" {
##  value = "${aws_instance.kubernetes_master.execution_results[0].environment["my_variable"]}"
##}
#
#
## Use the "null_resource" to define a local command to execute
## the SSH command and capture the output
#resource "null_resource" "example" {
#  provisioner "local-exec" {
#    command = "ssh ubuntu@${aws_instance.kubernetes_master.public_ip} 'echo hello, world'"
#    interpreter = ["/bin/bash", "-c"]
#    # Use this attribute to capture the output
#    # of the local-exec command
#    # in a variable named "my_variable"
#    environment = {
#      my_variable = "${self.execution_results[0].stdout}"
#    }
#  }
#}
#
## Define an output variable to make the value
## of the "my_variable" variable available to
## other resources or modules
#output "example_output" {
#  value = "${null_resource.example.execution_results[0].environment["my_variable"]}"
#}
