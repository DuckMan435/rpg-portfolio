# Clean previous build
Remove-Item -Path package -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path lambda.zip -Force -ErrorAction SilentlyContinue

# Install dependencies using Docker for Linux compatibility
docker run --rm -v "${PWD}:/var/task" --entrypoint pip public.ecr.aws/lambda/python:3.12 install -r /var/task/requirements.txt -t /var/task/package/ --upgrade

# Copy app folder into package
Copy-Item -Path app -Destination package/app -Recurse

# Zip the package folder contents
Compress-Archive -Path package/* -DestinationPath lambda.zip