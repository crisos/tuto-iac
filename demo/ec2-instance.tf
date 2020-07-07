/* resource "aws_instance" "terraform-host" {

ami ="ami-0ffd59b53e6797671"

instance_type = "t2.micro"
key_name = "integcontinue"
provisioner "remote-exec" {
connection {
      host = "self.public_ip"
      user = "ec2-user"
      private_key = file("integcontinue.pem")
}
    inline = [

      "sudo yum -y update",
      "sudo yum -y install httpd",

    ]

  }

} */
/* resource "aws_instance" "example" {
  ami           = "ami-08f4717d06813bf00"
  instance_type = "t2.micro"

  provisioner "local-exec" {
    command = "echo ${aws_instance.example.public_ip} > ip_address.txt"
  }
} */

resource "aws_key_pair" "example" {
  key_name   = "examplekey"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "example" {
  key_name      = aws_key_pair.example.key_name
  ami           = "ami-08f4717d06813bf00"
  instance_type = "t2.micro"

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras enable nginx1.12",
      "sudo yum -y install nginx",
      "sudo systemctl start nginx"
    ]
  }
}