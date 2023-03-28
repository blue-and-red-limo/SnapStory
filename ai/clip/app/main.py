from fastapi import FastAPI

from fastapi import File, UploadFile

# 유니크한 파일이름 생성하기 위해
import uuid

# 파일 저장을 위한 현재 경로를 알기 위해
import os

# 예측 함수 import.
from app.model.clip import predict

# base64 decoding을 위한 import.
import base64
# base64 encoding된 str 형식 지정하기 위해.
from pydantic import BaseModel

# application 시작 전에 prediciton에 필요한 모듈들을 미리 import하기위해.
from contextlib import asynccontextmanager

# 사진을 저장하지 않고 진행. byte format을 file-like object로 만들어줌. preidct 함수에서 Image.open 가능하게.
import io

# # 'base64_to_numpy' 함수에 사용.
# from io import BytesIO
# from PIL import Image
# import numpy as np

# yield 이전 코드는 어플 시작 전에, yield 이후 코드는 어플 시작 후에.
@asynccontextmanager
async def lifespan(app: FastAPI):
    print("#################before yield#################")
    yield

app = FastAPI(lifespan=lifespan)

class Base64Request(BaseModel):
    base64_file: str

IMAGEDIR=os.getcwd()+"/app/images/"
CNNDIR=os.getcwd()+"/app/model/"

# cnn tensorflow model load
import os
from tensorflow.python.keras import layers
from tensorflow import keras
import tensorflow as tf

# # Define the model architecture on the server side
# model = keras.Sequential()
# model.add(layers.Convolution2D(16,(3,3),
#                                padding='same',
#                                input_shape=(28, 28, 1),activation='relu'))
# model.add(layers.MaxPooling2D(pool_size=(2,2)))
# model.add(layers.Convolution2D(32,(3,3), padding='same', activation='relu'))
# model.add(layers.MaxPooling2D(pool_size=(2,2)))
# model.add(layers.Convolution2D(64,(3,3), padding='same', activation='relu'))
# model.add(layers.MaxPooling2D(pool_size=(2,2)))
# model.add(layers.Flatten()) # vector form으로.
# model.add(layers.Dense(128,activation='relu'))
# model.add(layers.Dense(15,activation='softmax'))

# # Load model weights
# model.load_weights('keras_weights.h5')

@app.get("/ai")
def home():
    return "서버 접속 성공!!"

# 사진 이미지 분류
@app.post("/ai/predictions/objects")
async def predictions_objects(file: UploadFile = File(...)):
    # 파일 이름 유니크하게 설정
    file.filename = f"{uuid.uuid4()}.jpg"

    # 사진 읽어오기.
    contents = await file.read()

    # 사진 저장
    # with open(f"{IMAGEDIR}{file.filename}","wb") as f:
    #     f.write(contents)

    # 저장하지 않고 진행.
    image = io.BytesIO(contents)

    return predict(image,"objects")

# CLIP 손그림 이미지 분류
@app.post("/ai/predictions/drawings")
async def predictions_drawings(request: Base64Request):
    file_content = request.base64_file

    # 빈 file 생성
    # file = File(...)

    # 파일 이름 유니크하게 설정
    # file.filename = f"{uuid.uuid4()}.jpg"

    # image decoding
    contents = base64.b64decode(file_content)

    # 사진 저장
    # with open(f"{IMAGEDIR}{file.filename}","wb") as f:
    #     f.write(contents)

    # 저장하지 않고 진행.
    image = io.BytesIO(contents)

    return predict(image,"drawings")

# # CNN 손그림 이미지 분류
# @app.post("/ai/cnn/predictions/doodles")
# async def cnn_prediction(request: Base64Request):
#     image_numpy = base64_to_numpy(request.base64_file)
#     print(image_numpy)

#     # 빈 file 생성
#     # file = File(...)

#     # 파일 이름 유니크하게 설정
#     # file.filename = f"{uuid.uuid4()}.jpg"

#     # image decoding
#     # contents = base64.b64decode(file_content)

#     # 사진 저장
#     # with open(f"{IMAGEDIR}{file.filename}","wb") as f:
#     #     f.write(contents)

#     # 저장하지 않고 진행.
#     # image = io.BytesIO(contents)

#     # return "predict(image,"drawings")"
#     return "success"


# # base64 encoded image file을 gray-scale (1,28,28,1) shape np array로.
# def base64_to_numpy(b64_string):
#     # Decode the base64 string into bytes
#     b64_bytes = base64.b64decode(b64_string)

#     # Open the image from the bytes
#     image = Image.open(BytesIO(b64_bytes))

#     # Convert the image to grayscale and resize it to (28, 28)
#     image = image.convert('L').resize((28, 28))

#     # Convert the image to a NumPy array
#     arr = np.array(image)

#     # Reshape the array to have shape (1, 28, 28, 1)
#     arr = arr.reshape((1, 28, 28, 1))

#     return arr
