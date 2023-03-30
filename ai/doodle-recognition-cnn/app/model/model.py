import os
from tensorflow.python.keras import layers
from tensorflow import keras

from app.model.simplify import align, scale, resample, rdp_simplify, vector_to_raster

import numpy as np

MODELDIR=os.getcwd()+"/app/model/"
CLASSDIR=os.getcwd()+"/app/model/"

def load_model():
    # Define the model architecture on the server side
    model = keras.Sequential()

    model.add(layers.Convolution2D(16,(3,3), padding='same', input_shape=(28, 28, 1),activation='relu'))
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
    model.load_weights(MODELDIR+'keras_weights.h5')

    return model

def load_classes():
    f= open(CLASSDIR+"class_names.txt","r")
    classes = f.readlines()
    f.close()
    classes = [c.replace('\n','').replace(' ','_') for c in classes]
    return classes

def preprocess(strokes):
    aligned_strokes = align(strokes)
    scaled_strokes = scale(aligned_strokes)
    resampled_strokes = [resample(stroke) for stroke in scaled_strokes]
    rdp_simplified_strokes= rdp_simplify(resampled_strokes)
    numpy_bitmap_data = vector_to_raster([rdp_simplified_strokes])[0]

    # 6. Reshape and normalize
    # float 타입으로 바꾸는 이유는 continuous data가 필요하기 때문에.
    image_size=28
    reshaped_data = numpy_bitmap_data.reshape(image_size,image_size,1).astype('float32')

    # normalize.
    reshaped_data /= 255.0

    # model input에 맞춰, dimensino 확장.
    expanded_data = np.expand_dims(reshaped_data,axis=0)

    return expanded_data


