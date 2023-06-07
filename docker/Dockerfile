# Arguments
# ARG CPU_ONLY=0 
# ARG PY_VERSION=3.11
# ARG CUDA_VERSION=11.1
ARG BASE_CONTAINER=jupyter/scipy-notebook

# Use a base Python image
FROM $BASE_CONTAINER

LABEL maintainer="Sebastian <sebastian@gbthome.com>"

# Fix DL4006
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Set the entrypoint to start servers
ENV BACKEND_STORE_URI /home/${NB_USER}/mlflow/store
ENV DEFAULT_ARTIFACT_ROOT /home/${NB_USER}/mlflow/artifacts
ENV AIM_UI_PORT=43800
ENV AIM_SERVER_PORT=53800
ENV MLFLOW_PORT=5000
# ENV JUPYTER_PORT=8888 #? Already defined in base image

# Expose the ports used by MLflow, Aim
EXPOSE $MLFLOW_PORT $AIM_UI_PORT $AIM_SERVER_PORT

USER root

# Install necessary dependencies for psycopg2 and other tools
RUN apt-get -q update && \ 
    apt-get install -yq --no-install-recommends \
    git gcc wget gdal-bin libgdal-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*


USER $NB_UID

# Install packages 
# Rapids AI doesn not support Python 3.11 yet
RUN mamba update --all -y \
    && mamba install -c rapidsai -c pytorch -c huggingface -c conda-forge -c anaconda -c nvidia --yes \
    'nomkl' \
    'ghostscript' \
    'rasterio' \
    'pytorch==2.*' \
    'torchvision' \
    'torchaudio' \
    'pytorch-cuda=11.8' \
    'gdal' \
    # 'cudf' \
    # 'cugraph' \
    # 'cuml' \
    'aim' \
    'mlflow' \
    'nltk' \ 
    'transformers' \
    'tqdm' \
    'pyarrow' \
    && mamba clean --all -f -y \
    && pip install \
        xgboost \
        aim-mlflow \
        argparse \
        astropy \
        bowtie \
        fastai \
        imutils \
        keras \
        keras-tuner \
        nbgitpuller \
        opencv-python \
        psycopg2-binary \
        requests \
        tensorflow-probability \
        visualdl \
        git+https://github.com/veeresht/CommPy.git \
        bash_kernel \
    && python -m bash_kernel.install \
    && jupyter nbextension enable --py widgetsnbextension --sys-prefix \
    && jupyter labextension install @jupyterlab/hub-extension \
    && jupyter serverextension enable --py nbgitpuller --sys-prefix \
    && fix-permissions "${CONDA_DIR}" \
    && fix-permissions "/home/${NB_USER}"

USER root

# Copy a script that starts all the services
COPY start_toolkit.sh /usr/local/bin/start_toolkit.sh
RUN chown $NB_UID /usr/local/bin/start_toolkit.sh && chmod +x /usr/local/bin/start_toolkit.sh

# Switch back to jovyan to avoid accidental container runs as root
USER ${NB_UID}

ENTRYPOINT ["start_toolkit.sh"]

# Set the working directory in the container
WORKDIR $HOME