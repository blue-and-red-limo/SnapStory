from PIL import Image, ImageDraw

def show_image(strokes,width,height):
    width = width
    height = height
    image = Image.new("RGB", (width, height), (255, 255, 255))
    draw = ImageDraw.Draw(image)

    for stroke in strokes:
        print("len(stroke)",len(stroke))
        print("len(stroke[0])",len(stroke[0]))
        print("len(stroke[1])",len(stroke[1]))
        x_coords, y_coords = stroke
        points = list(zip(x_coords, y_coords))
        draw.line(points, fill=0, width=5)

    image.show()
