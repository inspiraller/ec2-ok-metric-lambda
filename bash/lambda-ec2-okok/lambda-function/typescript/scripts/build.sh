#!/bin/sh

container="lambda-zipper"
scriptname="create-lambda-zip.sh"
zipname="lambda-function.zip"

start_time=$(date +%s)
echo "start build zip"

echo "1. remove any existing running container"
docker stop $container && docker rm $container

echo "2. If NOT exist docker build container ${container}"
docker image inspect $container >/dev/null 2>&1 || docker build . -t "$container:latest"

echo "3. run ${container}. Note: Dockerfile in sleep mode"
docker run -d --name $container $container

echo "4. Copy script to container."
docker cp $scriptname "${container}:/app/"

echo "5. Create build of javascript files to dist/"
pnpm exec tsc && cp ../package.json ../dist/ 

echo "6. Copy contents of dist to container"
docker cp ../dist/. "${container}:/app/dist"

echo "7. Exec the script. This will install node_modules from within the container in a compatible aws image format, and then zip it"
docker exec $container sh $scriptname


echo "8. Copy the contents back to windows, to send to aws in create lambda function. The zip is not compatible."
docker cp $container:app/dist/$zipname ../


echo "9. Remove the docker container. We don't need this running."
docker stop $container && docker rm $container


echo "10. Remove dist/ folder"
rm -rf ../dist/node_modules ../dist/package-lock.json ../dist/package.json


end_time=$(date +%s)

# Calculate the duration
duration=$((end_time - start_time))

echo "Complete Time: $duration seconds"