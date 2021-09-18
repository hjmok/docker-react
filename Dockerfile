#Dockerfile.dev Container for just development
#Production container is just called Dockerfile
#https://www.udemy.com/course/docker-and-kubernetes-the-complete-guide/learn/lecture/11437096#questions

#Build Phase
#Specify a base image, by using existing docker image 'node:alpine' and tagging it with nickname 'builder'
#node:alpine is like an OS, as it comes with a lot of useful pre-installed programs for us to use as our base image
FROM node:alpine as builder

#USER node
#RUN mkdir -p /home/node/app
WORKDIR '/app'

#Install some dependencies
#we are using COPY to take the package.json file in our FRONTEND directory, as they are outside of our base container
COPY package.json .
RUN npm install 
#COPY the rest including index.js. So we did this because we don't want to copy everything at once if a change is made to index.js. This way, we separated our copies so the cache for package.json remains if it's not changed, and only index.js copy is executed. 
COPY . .

#This is the last step of the build phase. So this container will run npm run build and the output will go into the build folder
RUN npm run build



#Run Phase
FROM nginx
EXPOSE 80
#Copy stuff over from the Build Phase above, where we tagged as "builder"
#When starting the nginx container, it will start nginx for us, no specific command needed
COPY --from=builder /app/build /usr/share/nginx/html