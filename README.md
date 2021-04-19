
# Dockerizing moses server
To make the process of deploying moses server easier and faster, we dockerize the installation of moses server on a ubunto server with all it's dependecies and needed packages.

# Required Technology
[docker](docker.io)

# How to include my models and deploy them using moses server?
* Create your ownn Dockerfile
* Pull the moses_server image from dockerhub
* Copy your models into the working directory you want
* Expose the port you want your service to use
* Edit the entrypoint.sh file to run tht command you want moses server to run
* Then build your image
`docker build . -t my_moses_server`


# How to run moses server with the proper model and specifed port?
You can run through the following command
` docker run --rm  --name moses_server -it \
                -v ${PWD}/moses-models:/home/moses/moses-models \
                -p 8085:8085 \
                my_moses_server`





