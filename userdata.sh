 #!/bin/bash
              sudo su
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello World from $(hostname -f). Welcome to my page</h1>" > /var/www/html/index.html