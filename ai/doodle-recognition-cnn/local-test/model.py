import os
from tensorflow.python.keras import layers
from tensorflow import keras
import tensorflow as tf

CNNDIR=os.getcwd()+"/app/model/"

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