from fastapi import FastAPI
from pydantic import BaseModel

# 'base64_to_numpy' 함수에 사용.
import base64
from io import BytesIO
from PIL import Image
import numpy as np

# for cnn tensorflow model load
import os
from tensorflow.python.keras import layers
from tensorflow import keras
import tensorflow as tf

f= open(os.getcwd()+"/app/model/mini_classes.txt","r")
# And for reading use
classes = f.readlines()
f.close()

_classes = [c.replace('\n','').replace(' ','_') for c in classes]

app = FastAPI()

CNNDIR=os.getcwd()+"/app/model/"

class Base64Request(BaseModel):
    base64_file: str

@app.get("/")
def home():
    return {"server connected"}

@app.post("/ai/predictions/doodles")
async def predict(request: Base64Request):

    print("before load_model()")
    model = load_model()
    print("after load_model()")

    image_numpy = base64_to_numpy(request.base64_file)
    image_numpy2 = image_numpy/255.0

    
    pred=model.predict(image_numpy)[0]
    print(pred)
    ind = (-pred).argsort()[:5]
    latex = [_classes[x]for x in ind]
    print(latex)

    pred2=model.predict(image_numpy2)[0]
    print(pred2)
    ind = (-pred2).argsort()[:5]
    latex2 = [_classes[x]for x in ind]
    print(latex2)

    return latex

def load_model():
    # Define the model architecture on the server side
    model = keras.Sequential()
    model.add(layers.Convolution2D(16,(3,3),
                                padding='same',
                                input_shape=(28, 28, 1),activation='relu'))
    model.add(layers.MaxPooling2D(pool_size=(2,2)))
    model.add(layers.Convolution2D(32,(3,3), padding='same', activation='relu'))
    model.add(layers.MaxPooling2D(pool_size=(2,2)))
    model.add(layers.Convolution2D(64,(3,3), padding='same', activation='relu'))
    model.add(layers.MaxPooling2D(pool_size=(2,2)))
    model.add(layers.Flatten()) # vector form으로.
    model.add(layers.Dense(128,activation='relu'))
    model.add(layers.Dense(15,activation='softmax'))

    # build the model's variables
    model.build(input_shape=(1,28, 28, 1))  

    # Load model weights
    model.load_weights(CNNDIR+'keras_weights.h5')

    return model

# base64 encoded image file을 gray-scale (1,28,28,1) shape np array로.
def base64_to_numpy(b64_string):
    # Decode the base64 string into bytes
    b64_bytes = base64.b64decode(b64_string)

    # Open the image from the bytes
    image = Image.open(BytesIO(b64_bytes))

    # Convert the image to grayscale and resize it to (28, 28)
    image = image.convert('L').resize((28, 28))

    # Convert the image to a NumPy array
    arr = np.array(image)

    # Reshape the array to have shape (1, 28, 28, 1)
    arr = arr.reshape((1, 28, 28, 1))

    return arr