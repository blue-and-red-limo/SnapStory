from shapely.geometry import LineString

def align(strokes):
    min_x = min([min(stroke[0]) for stroke in strokes])
    min_y = min([min(stroke[1]) for stroke in strokes])

    aligned_strokes = []
    for stroke in strokes:
        aligned_stroke = [[x - min_x for x in stroke[0]], [y - min_y for y in stroke[1]]]
        aligned_strokes.append(aligned_stroke)

    return aligned_strokes

def scale(data):
    # Find the minimum and maximum x and y values
    min_x = min(min(stroke[0]) for stroke in data)
    max_x = max(max(stroke[0]) for stroke in data)
    min_y = min(min(stroke[1]) for stroke in data)
    max_y = max(max(stroke[1]) for stroke in data)
    
    # Calculate the range of the x and y values
    range_x = max_x - min_x
    range_y = max_y - min_y
    
    # Determine the scaling factor
    scaling_factor = 255 / max(range_x, range_y)
    
    # Scale the data
    for stroke in data:
        for i in range(len(stroke[0])):
            stroke[0][i] = int((stroke[0][i] - min_x) * scaling_factor)
            stroke[1][i] = int((stroke[1][i] - min_y) * scaling_factor)
    
    return data

def resample(stroke, spacing=1):
    # Convert stroke to a list of (x, y) tuples
    points = [(stroke[0][i], stroke[1][i]) for i in range(len(stroke[0]))]

    # Calculate the length of the stroke
    stroke_len = 0
    for i in range(len(points) - 1):
        stroke_len += ((points[i + 1][0] - points[i][0]) ** 2 + (points[i + 1][1] - points[i][1]) ** 2) ** 0.5

    # Calculate the number of points to sample
    num_points = int(round(stroke_len / spacing))

    # Sample the stroke
    resampled_points = []
    for i in range(num_points):
        # Calculate the position of the current point along the stroke
        pos = float(i) / (num_points - 1) * stroke_len

        # Find the two points that bracket the current position
        j = 0
        while j < len(points) - 2 and pos > ((points[j + 1][0] - points[j][0]) ** 2 + (points[j + 1][1] - points[j][1]) ** 2) ** 0.5:
            pos -= ((points[j + 1][0] - points[j][0]) ** 2 + (points[j + 1][1] - points[j][1]) ** 2) ** 0.5
            j += 1

        # Interpolate the position of the current point
        x = points[j][0] + pos / ((points[j + 1][0] - points[j][0]) ** 2 + (points[j + 1][1] - points[j][1]) ** 2) ** 0.5 * (points[j + 1][0] - points[j][0])
        y = points[j][1] + pos / ((points[j + 1][0] - points[j][0]) ** 2 + (points[j + 1][1] - points[j][1]) ** 2) ** 0.5 * (points[j + 1][1] - points[j][1])

        resampled_points.append((x, y))

    # Convert resampled points back to original format
    resampled_stroke = [
        [resampled_points[i][0] for i in range(num_points)],
        [resampled_points[i][1] for i in range(num_points)]
    ]

    return resampled_stroke

def rdp_simplify(strokes):
    simplified_data = []
    for stroke in strokes:
        line = LineString(list(zip(stroke[0], stroke[1])))
        simplified_line = line.simplify(2.0)
        simplified_stroke = [simplified_line.xy[0].tolist(), simplified_line.xy[1].tolist()]
        simplified_data.append(simplified_stroke)
    return simplified_data

import numpy as np
import cairocffi as cairo

def vector_to_raster(vector_images, side=28, line_diameter=16, padding=16, bg_color=(0,0,0), fg_color=(1,1,1)):
    """
    padding and line_diameter are relative to the original 256x256 image.
    """
    
    original_side = 256.
    
    surface = cairo.ImageSurface(cairo.FORMAT_ARGB32, side, side)
    ctx = cairo.Context(surface)
    ctx.set_antialias(cairo.ANTIALIAS_BEST)
    ctx.set_line_cap(cairo.LINE_CAP_ROUND)
    ctx.set_line_join(cairo.LINE_JOIN_ROUND)
    ctx.set_line_width(line_diameter)

    # scale to match the new size
    # add padding at the edges for the line_diameter
    # and add additional padding to account for antialiasing
    total_padding = padding * 2. + line_diameter
    new_scale = float(side) / float(original_side + total_padding)
    ctx.scale(new_scale, new_scale)
    ctx.translate(total_padding / 2., total_padding / 2.)

    raster_images = []
    for vector_image in vector_images:
        # clear background
        ctx.set_source_rgb(*bg_color)
        ctx.paint()
        
        bbox = np.hstack(vector_image).max(axis=1)
        offset = ((original_side, original_side) - bbox) / 2.
        offset = offset.reshape(-1,1)
        centered = [stroke + offset for stroke in vector_image]

        # draw strokes, this is the most cpu-intensive part
        ctx.set_source_rgb(*fg_color)        
        for xv, yv in centered:
            ctx.move_to(xv[0], yv[0])
            for x, y in zip(xv, yv):
                ctx.line_to(x, y)
            ctx.stroke()

        data = surface.get_data()
        raster_image = np.copy(np.asarray(data)[::4])
        raster_images.append(raster_image)
    
    return raster_images