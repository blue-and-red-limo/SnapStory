from fastapi import FastAPI
# from pydantic import BaseModel
# from temp.model import predict_pipeline
# from temp.model import __version__ as model_version

from fastapi import File, UploadFile
import uuid

import os

from app.model.clip import predict_objects, predict_drawings

# base64 decoding을 위한 import.
import base64
from PIL import Image
from io import BytesIO
# base64 encoding된 str 형식 지정하기 위해.
from pydantic import BaseModel

app = FastAPI()

class Base64Request(BaseModel):
    base64_file: str

IMAGEDIR=os.getcwd()+"/app/images/"

@app.get("/ai")
def home():
    return "서버 접속 성공!!"

# 실제 사용할 api
@app.post("/ai/predictions/objects")
async def predictions_objects(file: UploadFile = File(...)):
    # 파일 이름 유니크하게 설정
    file.filename = f"{uuid.uuid4()}.jpg"

    # 사진 읽어오기.
    contents = await file.read()

    # 사진 저장
    with open(f"{IMAGEDIR}{file.filename}","wb") as f:
        f.write(contents)

    return predict_objects(file.filename)

@app.post("/ai/predictions/drawings")
async def predictions_drawings(request: Base64Request):
    print("predictions_drawings in")
    print(request.base64_file)
    
    file_content = request.base64_file
    print("########################file content:",file_content)
    # file 생성
    file = File(...)

    # 파일 이름 유니크하게 설정
    file.filename = f"{uuid.uuid4()}.jpg"

    # image decoding
    # img = Image.open(BytesIO(base64.b64decode(file_content)))
    contents = base64.b64decode(file_content)

    # 사진 읽어오기.
    # contents = await img.read()

    # 사진 저장
    with open(f"{IMAGEDIR}{file.filename}","wb") as f:
        f.write(contents)

    return predict_drawings(file.filename)

#############################################################
# local에서 테스트하는 api
# @app.post("/ai/test/predictions/drawings")
# async def predict_drawings_test(file: UploadFile = File(...)):
    
#     file.filename = f"{uuid.uuid4()}.jpg"
#     contents = await file.read()

#     print("os.getcwd():"+os.getcwd())

#     # save the file
#     with open(f"{IMAGEDIR}{file.filename}","wb") as f:
#         f.write(contents)

#     return model_test_predict(file.filename)
