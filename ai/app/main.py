from fastapi import FastAPI
from pydantic import BaseModel
from app.model.model import predict_pipeline
from app.model.model import __version__ as model_version

from fastapi import File, UploadFile
import uuid

app = FastAPI()

IMAGEDIR="images/"

class TextIn(BaseModel):
    text: str


class PredictionOut(BaseModel):
    language: str


@app.get("/ai")
def home():
    return {"health_check": "OK", "model_version": model_version}


@app.post("/ai/predict", response_model=PredictionOut)
def predict(payload: TextIn):
    language = predict_pipeline(payload.text)
    return {"language": language}

@app.post("/ai/predictions/drawings")
def predict(file: UploadFile = File(...)):
    
    file.filename = f"{uuid.uuid4()}.jpg"
    contents = file.read()

    # save the file
    with open(f"{IMAGEDIR}{file.filename}","wb") as f:
        f.write(contents)

    return