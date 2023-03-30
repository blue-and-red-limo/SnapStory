def align_top_left(strokes):
    min_x = min([min(stroke[0]) for stroke in strokes])
    min_y = min([min(stroke[1]) for stroke in strokes])

    aligned_strokes = []
    for stroke in strokes:
        aligned_stroke = [[x - min_x for x in stroke[0]], [y - min_y for y in stroke[1]]]
        aligned_strokes.append(aligned_stroke)

    return aligned_strokes
