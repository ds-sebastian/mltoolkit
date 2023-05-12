#!/bin/sh

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
aim server --host 0.0.0.0 --port $AIM_SERVER_PORT &

# Start Aim UI
aim up --host 0.0.0.0 --port $AIM_UI_PORT & 

# Sync Aim with MLflow
aimlflow sync --mlflow-tracking-uri=http://0.0.0.0:$MLFLOW_PORT --aim-repo=/mltoolkit/aim &

# Start Jupyter Lab
jupyter lab --ip=0.0.0.0 --port=$JUPYTER_PORT --no-browser &

# Keep the script running
tail -f /dev/null
