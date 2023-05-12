# ML Docker Toolkit
This is a Docker toolkit specifically designed for machine learning. It includes several key tools and libraries including PyTorch, Mamba, MLflow, Aim, JupyterLab, and many more.

## Features
- Based on the lightweight python:slim-bullseye image.
- Installs the psycopg2 dependencies for PostgreSQL support.
- Containerized environment: Ensures that your machine learning environment is isolated and reproducible.
- Comprehensive: Includes most of the tools you'll need for machine learning tasks.
- Flexible: Easily switch between CPU and GPU environments using a build argument. *WIP*

## Usage 

1. Build the Docker image:
```sh
docker build --build-arg CPU_ONLY=0 --build-arg PY_VERSION=3.11 --build-arg CUDA_VERSION=11.1 -t ml-toolkit .
```
The CPU_ONLY build argument determines whether the toolkit should be built for CPU only (1) or if it should include support for CUDA (0). You can also specify the Python and CUDA versions using the PY_VERSION and CUDA_VERSION build arguments.

After building the image, you can create a new container using the following command:

2. Run the Docker container:
```sh
docker run -it -p 5000:5000 -p 43800:43800 -p 53800:53800 -p 8888:8888 ml-toolkit
```

## Services
The Docker image includes several services that are started automatically when a new container is created:

MLflow server: A platform to manage the ML lifecycle, including experimentation, reproducibility, and deployment.
Aim server and UI: A version control system for AI development. It allows you to version, manage, and collaborate on AI models.
JupyterLab: A web-based interactive development environment for Jupyter notebooks, code, and data.
These services are managed by a script (start_toolkit.sh) that is copied into the Docker image.

Access the MLflow and Aim UIs in your browser:
- MLflow: http://localhost:5000
- Aim: http://localhost:43800
- JupyterLab: http://localhost:8888

## Note
This Dockerfile assumes that you are using the local filesystem for MLflow backend storage and artifact storage. If you wish to use other storage options, modify the `BACKEND_STORE_URI` and `DEFAULT_ARTIFACT_ROOT` environment variables accordingly.
