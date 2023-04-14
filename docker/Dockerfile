# Use a base Python image
FROM python:3.10-slim-bullseye

# Install necessary dependencies for psycopg2
RUN apt-get update && apt-get install -y \
        gcc \
        libpq-dev \
        && rm -rf /var/lib/apt/lists/*

# Install Aim, MLflow, and their dependencies
RUN pip install --no-cache-dir \
        Cython==3.0.0a9 \
        aim \
        mlflow

# Create working directory and initialize Aim
WORKDIR /opt/aim
RUN aim init

# Expose the ports used by MLflow and Aim
EXPOSE 5000 43800 53800

# Set environment variable for backend-store-uri
ENV BACKEND_STORE_URI /opt/aim/mlflow/store
ENV DEFAULT_ARTIFACT_ROOT /opt/aim/mlflow/artifacts

# Set the entrypoint to start both servers
CMD /bin/sh -c "\
    mlflow server \
        --host 0.0.0.0 \
        --port 5000 \
        --backend-store-uri ${BACKEND_STORE_URI} \
        --default-artifact-root ${DEFAULT_ARTIFACT_ROOT} \
        & \
    aim up --host 0.0.0.0 --port 43800 & \
    aim server --host 0.0.0.0 --port 53800 \
    "
