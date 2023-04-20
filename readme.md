# ML Docker Toolkit
This Dockerfile creates an image that integrates the MLflow and Aim platforms, providing a unified environment for tracking, visualizing, and managing machine learning experiments. It sets up the necessary dependencies, installs the required packages, and configures the environment for smooth operation.

## Features
- Based on the lightweight python:3.10-slim-bullseye image.
- Installs the psycopg2 dependencies for PostgreSQL support.
- Installs Aim, MLflow, and their dependencies.
- Exposes the default ports used by MLflow (5000) and Aim (43800, 53800).
- Sets the environment variables for MLflow backend storage and artifact storage.
- Configures the entrypoint to start both servers and synchronize Aim and MLflow.

## Usage 

1. Build the Docker image:
```sh
docker build -t mlflow-aim-integration .
```
2. Run the Docker container:
```sh
docker run -d --name mlflow-aim -p 5000:5000 -p 43800:43800 -p 53800:53800 mlflow-aim-integration
```

3. Access the MLflow and Aim UIs in your browser:
- MLflow: http://localhost:5000
- Aim: http://localhost:43800

4. To stop and remove the Docker container:
```sh
docker stop mlflow-aim && docker rm mlflow-aim
```

## Note
This Dockerfile assumes that you are using the local filesystem for MLflow backend storage and artifact storage. If you wish to use other storage options, modify the `BACKEND_STORE_URI` and `DEFAULT_ARTIFACT_ROOT` environment variables accordingly.
