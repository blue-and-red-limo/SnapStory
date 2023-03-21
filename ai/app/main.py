from fastapi import FastAPI

from fastapi import File, UploadFile

# 유니크한 파일이름 생성하기 위해
import uuid

# 파일 저장을 위한 현재 경로를 알기 위해
import os

# 예측 함수 import.
from app.model.clip import predict_objects, predict_drawings, predict

# base64 decoding을 위한 import.
import base64
# base64 encoding된 str 형식 지정하기 위해.
from pydantic import BaseModel

# application 시작 전에 prediciton에 필요한 모듈들을 미리 import하기위해.
from contextlib import asynccontextmanager

# yield 이전 코드는 어플 시작 전에, yield 이후 코드는 어플 시작 후에.
@asynccontextmanager
async def lifespan(app: FastAPI):
    print("#################before yield#################")
    yield

app = FastAPI(lifespan=lifespan)

class Base64Request(BaseModel):
    base64_file: str

IMAGEDIR=os.getcwd()+"/app/images/"

@app.get("/")
def root():
    print("##############root#############")
    return "root"

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

    return predict(file.filename,"objects")

@app.post("/ai/predictions/drawings")
async def predictions_drawings(request: Base64Request):
    file_content = request.base64_file

    # 빈 file 생성
    file = File(...)

    # 파일 이름 유니크하게 설정
    file.filename = f"{uuid.uuid4()}.jpg"

    # image decoding
    contents = base64.b64decode(file_content)

    # 사진 저장
    with open(f"{IMAGEDIR}{file.filename}","wb") as f:
        f.write(contents)

    return predict(file.filename,"drawings")