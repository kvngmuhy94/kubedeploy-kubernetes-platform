from fastapi import FastAPI

app = FastAPI(
    title="KubeDeploy API",
    description="A Kubernetes deployment portfolio project",
    version="1.0.0"
)

@app.get("/")
def root():
    return {
        "message": "KubeDeploy API is running"
    }

@app.get("/health")
def health():
    return {
        "status": "healthy"
    }

@app.get("/ready")
def ready():
    return {
        "status": "ready"
    }
