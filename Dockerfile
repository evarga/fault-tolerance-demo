FROM --platform=$BUILDPLATFORM python:alpine3.19 AS production

WORKDIR /app
COPY app.py requirements.txt ./
# Install all required packages as specified in the 'requirements.txt' file
RUN --mount=type=cache,target=/root/.cache/pip \
    pip3 install --trusted-host pypi.python.org -r requirements.txt && rm requirements.txt

EXPOSE 8080

# We should not run our application as a root process.
RUN <<EOF
addgroup -S docker
adduser -S --shell /bin/bash --ingroup docker runner
EOF
USER runner

ENTRYPOINT ["python3"]
CMD ["app.py"]

# The rest of this file configures the Docker Dev Environments facility.
FROM production as development

USER root

RUN <<EOF
# We don't need an overlaid copy of app.py, so remove it.
rm app.py
apk update
apk add git docker docker-compose bash
EOF