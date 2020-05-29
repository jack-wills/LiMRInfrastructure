# LiMR Infrastructure

Infrastructure code for Manchester university 4th year project. Class of 2020, Team 2, LiMR: Blurring the lines between virtual and real worlds.

The aim of this project was to create a virtual environment that will be used by technicians to remotely inspect a HVDC substation.

Other associated repositories can be found under LiMRMainApplication and LiMRTeleoperationalRobot.

Infrastructure for LiMR using Terraform and AWS.

## To Run

First and AWS account must be created
Then both aws and terraform CLI tools must be downloaded

After terraform is verified to be working on your computer and can create infrastructure in your AWS account, run within this directory:
```
terraform init
```

Now on we can run the following snippit to apply the infrastructure to our AWS account.
```
./deploy.sh lambda
```
The lambda argument must be specified on the first run and after changes to the lambda java code has been made. The argument will rebuild the java packages. This argument is not needed after the first run if no changes to the java code have been made.