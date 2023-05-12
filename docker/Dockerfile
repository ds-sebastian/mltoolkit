# Arguments
ARG CPU_ONLY=0 
ARG PY_VERSION=3.11
ARG CUDA_VERSION=11.1

# Use a base Python image
FROM python:${PY_VERSION}-slim-buster

LABEL maintainer="Sebastian <sebastian@domain.com>"

# Set the working directory in the container
WORKDIR /mltoolkit

# Install necessary dependencies for psycopg2 and other tools Python and Mamba
RUN apt-get update && \
    apt-get install -y --no-install-recommends\
    git \
    gcc \
    wget \ 
    libpq-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    wget "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-pypy3-Linux-x86_64.sh" && \
    bash Mambaforge-pypy3-Linux-x86_64.sh -b -p /opt/conda && \
    rm Mambaforge-pypy3-Linux-x86_64.sh 

# Set path to mamba
ENV PATH /opt/conda/bin:$PATH

# Create mltoolkit environment and install packages
RUN mamba update --all -y \
    && mamba create -n mltoolkit python=${PY_VERSION} \
    && echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc \
    && echo "conda activate mltoolkit" >> ~/.bashrc \
    && /bin/bash -c ". /opt/conda/etc/profile.d/conda.sh && conda activate mltoolkit \
    && mamba install \
    python \
    pip \
    psycopg2 \
    aim \
    mlflow \
    scikit-learn \
    matplotlib \
    seaborn \
    pandas \
    numpy \
    scipy \
    tqdm \
    ipywidgets \
    ipython \
    ipykernel \
    jupyterlab \
    -c conda-forge \
    && if [ \"${CPU_ONLY}\" -eq 1 ] ; then \
        mamba install pytorch torchvision torchaudio cpuonly -c pytorch -c conda-forge -y; \
    else \
        mamba install pytorch torchvision torchaudio pytorch-cuda=${CUDA_VERSION} -c pytorch -c nvidia -y ; \
    fi \
    && pip install aim-mlflow \
    && mamba clean --all -y"

# Expose the ports used by MLflow, Aim, JupyterLab
EXPOSE 5000 43800 53800 8888

# Set the entrypoint to start servers
ENV BACKEND_STORE_URI /mltoolkit/mlflow/store
ENV DEFAULT_ARTIFACT_ROOT /mltoolkit/mlflow/artifacts
ENV AIM_UI_PORT=43800
ENV AIM_SERVER_PORT=53800
ENV MLFLOW_PORT=5000
ENV JUPYTER_PORT=8888

# Copy a script that starts all the services
COPY start_toolkit.sh /mltoolkit/start_toolkit.sh
RUN chmod +x /mltoolkit/start_toolkit.sh

ENTRYPOINT ["/mltoolkit/start_toolkit.sh"]