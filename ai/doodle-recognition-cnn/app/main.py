from fastapi import FastAPI
from pydantic import BaseModel

from app.model.model import load_classes,load_model,preprocess

print('load_classes')
_classes = load_classes()
print('load_model')
_model=load_model()

app = FastAPI()

class Strokes(BaseModel):
    data: list[list[list[int]]]

# @app.get("/")
# def home():
#     return {"server connected"}

@app.post("/recognize/doodles")
async def predict_doodles(strokes: Strokes):
    data=strokes.data
    print(data)

    # 데이터 전처리
    preprocessd_data=preprocess(data)

    # predict
    pred=_model.predict(preprocessd_data)[0]
    index = (-pred).argsort()[:1]
    probability = pred[index[0]]*100
    prediction=_classes[index[0]]

    return {'prediction':prediction,'probability':probability}