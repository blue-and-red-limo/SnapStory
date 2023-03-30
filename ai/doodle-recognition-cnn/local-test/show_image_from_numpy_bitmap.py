from PIL import Image
import numpy as np

def show_image_28_28(numpy_bitmap_data):
    image = numpy_bitmap_data.reshape((28,28))
    img = Image.fromarray(np.uint8(image))
    img.show()
