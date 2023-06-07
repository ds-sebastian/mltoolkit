#!/bin/sh

# Create necessary directories if they do not exist
mkdir -p ${BACKEND_STORE_URI} ${DEFAULT_ARTIFACT_ROOT}

# Start the MLflow server
mlflow server \
    --host 0.0.0.0 \
    --port $MLFLOW_PORT \
    --backend-store-uri ${BACKEND_STORE_URI} \
    --default-artifact-root ${DEFAULT_ARTIFACT_ROOT} & 

# Initialize Aim
if [ ! -d ".aim" ]; then 
    aim init; 
fi

# Start the Aim server
aim server --host 127.0.0.1 --port $AIM_SERVER_PORT &

# Start Aim UI
aim up --host 127.0.0.1 --port $AIM_UI_PORT & 

# Sync Aim with MLflow
aimlflow sync --mlflow-tracking-uri=http://0.0.0.0:$MLFLOW_PORT --aim-repo=/home/${NB_USER}/aim &

# Start Jupyter Notebook using the base image's script
exec start-notebook.sh

# Keep the script running
# tail -f /dev/null