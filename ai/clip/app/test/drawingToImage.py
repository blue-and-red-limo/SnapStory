import json
from PIL import Image, ImageDraw

import os

DRAWINGDIR=os.getcwd()

# Open the JSON file
with open(f"{DRAWINGDIR}/app/test/data_ndjson/one_apple_simplified.ndjson", 'r') as f:
    # Loop through each line in the file
    for line in f:
        # Parse the JSON object
        data = json.loads(line)
        
        # Extract the image data and label
        image_data = data['drawing']
        label = data['word']
        
        # Create a new image
        img = Image.new('RGB', (256, 256), (255, 255, 255))
        draw = ImageDraw.Draw(img)
        
        # Draw the path on the image
        for stroke in data['drawing']:
            print("stroke:",stroke)
            for i in range(len(stroke[0])-1):
                draw.line((stroke[0][i], stroke[1][i], stroke[0][i+1], stroke[1][i+1]), fill='black', width=5)
        
        # Save the image file
        img.save(f'{label}.png')
