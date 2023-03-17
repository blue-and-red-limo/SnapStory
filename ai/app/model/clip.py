# 원래 .ipynb !pip install (conda instll하고, docker에는 requirements.txt에 적어줌.)
# !pip install datasets torch transformers

# 이미지 오픈을 위한 library import
from PIL import Image as PILImage
# 현재 경로를 가져오기 위한 library import
import os

import datasets

from datasets import Image, Dataset

# model initialization
from transformers import CLIPProcessor, CLIPModel

import torch

import numpy as np

def predict(filename):
    # debug
    print("predict in")

    # 전역변수
    IMAGEDIR=os.getcwd()+"/app/images/"

    # 사진 열기
    image=PILImage.open(IMAGEDIR+filename)

    # 사진 resizing 하기.
    resizedImage = image.resize(((int)(320/image.height*image.width),320))
    # OSError: cannot write mode RGBA as JPEG, jpg는 투명도를 저장 못하는 문제.
    resizedImage = resizedImage.convert('RGB')
    # resized된 이미지가 Image.Image 형식이므로 JPEG로 맞춰준다.
    resizedImage.save(IMAGEDIR+filename+'_resized.jpg', 'JPEG')
    # 확인.

    # 여전히 그대로이다. 파일을 다시 불러오기.
    image_resized = PILImage.open(IMAGEDIR+filename+'_resized.jpg')

    # Define the new feature structure
    features=datasets.Features(
                    {
                        "image": datasets.Image(),
                        "label": datasets.ClassLabel(
                            names=[
                                "monitor",
                                "laptop",
                                "keyboard",
                                "apple",
                                "tumbler",
                                "mouse",
                                "glasses",
                                "dinosaur",
                                "tayo",
                                "bus",
                                "bus toy",
                                "doll",
                                "joint doll"
                            ]
                        ),
                    }
                )

    # Create an empty dataset with the specified feature structure
    image_dataset =Dataset.from_dict({'image': [], 'label': []}, features=features)

    # 빈 dataset에 mouse 넣어보기
    feature = Image(decode=False)
    new_image = {'image': feature.encode_example(image_resized)}
    new_dataset=image_dataset.add_item({'image':new_image['image'],'label':'glasses'})

    # check labels in the dataset
    set(new_dataset['label'])

    # labels names 
    labels = new_dataset.info.features['label'].names

    # generate sentences
    clip_labels = [f"a photo of a {label}" for label in labels]

    # 모델 불러오기.
    model_id = "openai/clip-vit-base-patch32"
    processor = CLIPProcessor.from_pretrained(model_id)
    model = CLIPModel.from_pretrained(model_id)

    # if you have CUDA set it to the active device like this
    device = "cuda" if torch.cuda.is_available() else "cpu"
    # move the model to the device
    model.to(device)

    # create label tokens
    label_tokens = processor(
        text=clip_labels,
        padding=True,
        images=None,
        return_tensors='pt'
    ).to(device)

    label_tokens['input_ids'][0][:10]

    # encode tokens to sentence embeddings
    label_emb = model.get_text_features(**label_tokens)
    # detach from pytorch gradient computation
    label_emb = label_emb.detach().cpu().numpy()
    label_emb.shape

    label_emb.min(), label_emb.max()

    # normalization
    label_emb = label_emb / np.linalg.norm(label_emb, axis=0)
    label_emb.min(), label_emb.max()

    new_dataset[0]['image']

    image = processor(
        text=None,
        images=new_dataset[0]['image'],
        return_tensors='pt'
    )['pixel_values'].to(device)
    image.shape

    img_emb = model.get_image_features(image)
    img_emb.shape

    img_emb = img_emb.detach().cpu().numpy()

    scores = np.dot(img_emb, label_emb.T)

    # print(scores)
    # sum = np.sum(scores)
    # scores=scores/sum
    # print(scores)

    # get index of highest score
    pred = np.argmax(scores)

    # find text label with highest score
    return labels[pred]