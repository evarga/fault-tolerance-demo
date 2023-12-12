FROM --platform=$BUILDPLATFORM python:alpine3.19 AS build

WORKDIR /app
COPY app.py requirements.txt ./
# Install all required packages as specified in the 'requirements.txt' file
RUN --mount=type=cache,target=/root/.cache/pip \
    pip3 install --trusted-host pypi.python.org -r requirements.txt && rm requirements.txt

EXPOSE 8080
ENTRYPOINT ["python3"]
CMD ["app.py"]

# The rest of this file configures the Docker Dev Environments facility.
FROM build as dev-environments

RUN apk update && apk add git bash