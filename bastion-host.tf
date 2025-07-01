resource "aws_instance" "vprofile-bastion" {
  ami                         = lookup(var.AMIS, var.AWS_REGION)
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.vprofilekey.key_name
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  count                       = var.instance_count
  vpc_security_group_ids      = [aws_security_group.vprofile-bastion-sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install git mysql-client -y
              git clone -b vp-rem https://github.com/devopshydclub/vprofile-project.git
              mysql -h ${aws_db_instance.vprofile-rds.address} -u ${var.dbuser} -p${var.dbpass} accounts --ssl-mode=DISABLED < /home/ubuntu/vprofile-project/src/main/resources/db_backup.sql
              EOF

  tags = {
    Name    = "vprofile-bastion"
    PROJECT = "vprofile"
  }

  depends_on = [aws_db_instance.vprofile-rds]
}
