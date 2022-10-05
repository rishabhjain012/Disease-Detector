import random
import numpy as np
import base64
import torchvision
from flask import Flask, jsonify, request
from torchvision import datasets, models, transforms
import torch
import torch.nn as nn
import torch.optim as optim
import urllib.request
from torch.utils.data import DataLoader
import torchvision.transforms as T
from torch.nn import functional as F
from torchsummary import summary
import os
import io
import matplotlib.pyplot as plt
import cv2
from PIL import Image
from gevent.pywsgi import WSGIServer
from mega import Mega

app = Flask(__name__)


@app.route('/upload', methods=['POST'])
def upload():

    def outy(name):
        result = ""
        source = "D:\\cp301_app\\desc\\"
        filename = source+name+".txt"
        with open(filename, 'r') as file:
            for line in file:
                # print(line)
                result = result+line
        file.close()
        return result

    imagefile = request.files['image']
    imagefile.save("something.jpg")
    image_path = r'something.jpg'
    print("human")

    def createlink(onedrive_link):
        data_bytes64 = base64.b64encode(bytes(onedrive_link, 'utf-8'))

        data_bytes64_String = data_bytes64.decode(
            'utf-8').replace('/', '_').replace('+', '-').rstrip("=")

        resultUrl = f"https://api.onedrive.com/v1.0/shares/u!{data_bytes64_String}/root/content"
        return resultUrl

    link = "https://1drv.ms/u/s!Ama2WSdwf8m3n3AqS2u-zdQc7f3q"

    url = createlink(link)

    # urllib.request.urlretrieve(url, "disease_classifier.pt")
    print("human")
    print("create")
    print("link")
    # root = 'disease_classifier.pt'
    root = 'D:\\cp301_app\\api\\disease_classifier.pt'
    resnet18 = torchvision.models.resnet18(pretrained=True)
    resnet18.fc = torch.nn.Linear(in_features=512, out_features=5)
    resnet18.load_state_dict(torch.load(root))
    resnet18.eval()

    train_transform = torchvision.transforms.Compose([
        torchvision.transforms.Resize(size=(224, 224)),
        torchvision.transforms.RandomHorizontalFlip(),
        torchvision.transforms.ToTensor(),
        torchvision.transforms.Normalize(
            mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
    ])

    test_transform = torchvision.transforms.Compose([
        torchvision.transforms.Resize(size=(224, 224)),
        torchvision.transforms.ToTensor(),
        torchvision.transforms.Normalize(
            [0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
    ])
    print("predict")

    def predict_image_class(image_path):
        image_human = Image.open(image_path).convert('RGB')
        image_human = test_transform(image_human)
        # Please note that the transform is defined already in a previous code cell
        image_human = image_human.unsqueeze(0)
        output_human = resnet18(image_human)[0]
        probabilities_human = torch.nn.Softmax(dim=0)(output_human)
        probabilities_human = probabilities_human.cpu().detach().numpy()
        predicted_class_index_human = np.argmax(probabilities_human)
        predicted_class_name_human = class_names_human[predicted_class_index_human]
        return probabilities_human, predicted_class_index_human, predicted_class_name_human

    probabilities_human, predicted_class_index_human, predicted_class_name_human = predict_image_class(
        image_path)
    print("processed")
    print('Probabilities:', probabilities_human)
    print('Predicted class index:', predicted_class_index_human)
    # im = Image.open('normal.jpg')
    # im.show()
    output = outy(predicted_class_name_human)
    print('Predicted class name:', predicted_class_name_human)
    return jsonify({
        "processed": predicted_class_name_human,
        "desc": output
    })


# print("not")


class_names_human = ['Brain', 'Brain_tumor',
                     'NORMAL', "PNEUMONIA", "Tuberculosis"]

# print("not")


class ChestXRayDataset(torch.utils.data.Dataset):
    def __init__(self, image_dirs, transform):
        def get_images(class_name):
            images = [x for x in os.listdir(image_dirs[class_name]) if (x.lower().endswith(
                'jpeg') or x.lower().endswith('png') or x.lower().endswith('jpg'))]
            print(f'Found {len(images)} {class_name} examples')
            return images

        self.images = {}
        self.class_names_human = ['Brain', 'Brain_tumor',
                                  'NORMAL', "PNEUMONIA", "Tuberculosis"]

        for class_name in self.class_names_human:
            self.images[class_name] = get_images(class_name)

        self.image_dirs = image_dirs
        self.transform = transform

    def __len__(self):
        return sum([len(self.images[class_name]) for class_name in self.class_names_human])

    def __getitem__(self, index):
        class_name = random.choice(self.class_names_human)
        index = index % len(self.images[class_name])
        image_name = self.images[class_name][index]
        image_path = os.path.join(self.image_dirs[class_name], image_name)
        image = Image.open(image_path).convert('RGB')
        return self.transform(image), self.class_names_human.index(class_name)


# for PLANT
@app.route('/uploadplant', methods=['POST'])
def uploadplant():

    def out(name):
        result = ""
        source = "D:\\cp301_app\\desc\\"
        filename = source+name+".txt"
        with open(filename, 'r') as file:
            for line in file:
                # print(line)
                result = result+line
        file.close()
        return result
    print("plant")
    imagefile = request.files['image']
    imagefile.save("something_plant.jpg")
    image_pathy = r'something_plant.jpg'

    def createlinky(onedrive_link):
        data_bytes64 = base64.b64encode(bytes(onedrive_link, 'utf-8'))
        data_bytes64_String = data_bytes64.decode(
            'utf-8').replace('/', '_').replace('+', '-').rstrip("=")
        resultUrl = f"https://api.onedrive.com/v1.0/shares/u!{data_bytes64_String}/root/content"
        return resultUrl

    linky = "https://1drv.ms/u/s!Ama2WSdwf8m3n3NkrOKnWw8G9MfX"
    urly = createlinky(linky)
    #urllib.request.urlretreve(urly, "plant.pt")

    root = 'D:\\cp301_app\\api\\plant2.pt'
    out_features = 33
    net.fc = torch.nn.Linear(in_features=512, out_features=out_features)
    loss_fn = torch.nn.CrossEntropyLoss()
    optimizer = torch.optim.Adam(net.parameters(), lr=3e-5)
    net.load_state_dict(torch.load(root))

    probabilities, predicted_class_index, predicted_class_name = predict_image_class(
        image_pathy)

    print('Predicted class name:', predicted_class_name)
    # desc=""
    if (predicted_class_name.find("healthy") == -1):
        print(predicted_class_name)
        output = out(predicted_class_name)
        print(output)
        return jsonify({
            "processed": predicted_class_name,
            "desc": output
        })

    else:
        print("Thats a Healthy Plant")
        return jsonify({
            "processed": predicted_class_name
        })


class_names = ['Apple___Apple_scab', 'Apple___Black_rot', 'Apple___Cedar_apple_rust', 'Apple___healthy', 'Cherry_(including_sour)___healthy', 'Cherry_(including_sour)___Powdery_mildew', 'Corn_(maize)___Cercospora_leaf_spot Gray_leaf_spot', 'Corn_(maize)___Common_rust_', 'Corn_(maize)___Northern_Leaf_Blight', 'Grape___Black_rot', 'Grape___Esca_(Black_Measles)', 'Grape___healthy', 'Grape___Leaf_blight_(Isariopsis_Leaf_Spot)', 'Peach___Bacterial_spot', 'Peach___healthy', 'Pepper,_bell___Bacterial_spot',
               'Pepper,_bell___healthy', 'Potato___Early_blight', 'Potato___healthy', 'Potato___Late_blight', 'Tomato___Early_blight', 'Strawberry___healthy', 'Tomato___Bacterial_spot', 'Strawberry___Leaf_scorch', 'Tomato___Leaf_Mold', 'Tomato___Spider_mites Two-spotted_spider_mite', 'Tomato___Late_blight', 'Tomato___healthy', 'Tomato___Septoria_leaf_spot', 'Tomato___Target_Spot', 'Tomato___Tomato_Yellow_Leaf_Curl_Virus', 'Tomato___Tomato_mosaic_virus', 'Corn_(maize)___healthy']


def predict_image_class(image_pathy):
    image = Image.open(image_pathy).convert('RGB')
    image = test_transform(image)
    # Please note that the transform is defined already in a previous code cell
    image = image.unsqueeze(0)
    output = net(image)[0]
    probabilities = torch.nn.Softmax(dim=0)(output)
    probabilities = probabilities.cpu().detach().numpy()
    predicted_class_index = np.argmax(probabilities)
    predicted_class_name = class_names[predicted_class_index-1]
    return probabilities, predicted_class_index, predicted_class_name


class Inception(nn.Module):
    # `c1`--`c4` are the number of output channels for each path
    def __init__(self, in_channels, c1, c2, c3, c4, **kwargs):
        super(Inception, self).__init__(**kwargs)
        # Path 1 is a single 1 x 1 convolutional layer
        self.p1_1 = nn.Conv2d(in_channels, c1, kernel_size=1)
        # Path 2 is a 1 x 1 convolutional layer followed by a 3 x 3
        # convolutional layer
        self.p2_1 = nn.Conv2d(in_channels, c2[0], kernel_size=1)
        self.p2_2 = nn.Conv2d(c2[0], c2[1], kernel_size=3, padding=1)
        # Path 3 is a 1 x 1 convolutional layer followed by a 5 x 5
        # convolutional layer
        self.p3_1 = nn.Conv2d(in_channels, c3[0], kernel_size=1)
        self.p3_2 = nn.Conv2d(c3[0], c3[1], kernel_size=5, padding=2)
        # Path 4 is a 3 x 3 maximum pooling layer followed by a 1 x 1
        # convolutional layer
        self.p4_1 = nn.MaxPool2d(kernel_size=3, stride=1, padding=1)
        self.p4_2 = nn.Conv2d(in_channels, c4, kernel_size=1)

    def forward(self, x):
        p1 = F.relu(self.p1_1(x))
        p2 = F.relu(self.p2_2(F.relu(self.p2_1(x))))
        p3 = F.relu(self.p3_2(F.relu(self.p3_1(x))))
        p4 = F.relu(self.p4_2(self.p4_1(x)))
        # Concatenate the outputs on the channel dimension
        return torch.cat((p1, p2, p3, p4), dim=1)


b1 = nn.Sequential(nn.Conv2d(3, 64, kernel_size=7, stride=2, padding=3),
                   nn.ReLU(),
                   nn.MaxPool2d(kernel_size=3, stride=2, padding=1))
b2 = nn.Sequential(nn.Conv2d(64, 64, kernel_size=1),
                   nn.ReLU(),
                   nn.Conv2d(64, 192, kernel_size=3, padding=1),
                   nn.ReLU(),
                   nn.MaxPool2d(kernel_size=3, stride=2, padding=1))
b3 = nn.Sequential(Inception(192, 64, (96, 128), (16, 32), 32),
                   Inception(256, 128, (128, 192), (32, 96), 64),
                   nn.MaxPool2d(kernel_size=3, stride=2, padding=1))
b4 = nn.Sequential(Inception(480, 192, (96, 208), (16, 48), 64),
                   Inception(512, 160, (112, 224), (24, 64), 64),
                   Inception(512, 128, (128, 256), (24, 64), 64),
                   Inception(512, 112, (144, 288), (32, 64), 64),
                   Inception(528, 256, (160, 320), (32, 128), 128),
                   nn.MaxPool2d(kernel_size=3, stride=2, padding=1))
b5 = nn.Sequential(Inception(832, 256, (160, 320), (32, 128), 128),
                   Inception(832, 384, (192, 384), (48, 128), 128),
                   nn.AdaptiveAvgPool2d((1, 1)),
                   nn.Flatten())

net = nn.Sequential(b1, b2, b3, b4, b5, nn.Linear(1024, 512))

train_transform = torchvision.transforms.Compose([
    torchvision.transforms.Resize(size=(224, 224)),
    torchvision.transforms.RandomHorizontalFlip(),
    torchvision.transforms.ToTensor(),
    torchvision.transforms.Normalize(
        mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
])

test_transform = torchvision.transforms.Compose([
    torchvision.transforms.Resize(size=(224, 224)),
    torchvision.transforms.ToTensor(),
    torchvision.transforms.Normalize(
        mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
])


# for graph
@app.route('/uploadgraph', methods=['POST'])
def uploadgraph():
    print("graph")
    imagefile = request.files['image']
    imagefile.save("something1.jpg")
    path = r'something1.jpg'
    #path = r'./Inputimages/something.jpg'
   # path2 = r'./Inputimages/something1.jpg'
    src = cv2.imread(path)
    gray(src)
    rgb(src)
    print("success")

    return jsonify({
        "processed": "it is uploaded successfully we can continue"
    })


# print("not")


def gray(src):
    imagey = cv2.cvtColor(src, cv2.COLOR_BGR2GRAY)

    plt.hist(x=imagey.ravel(), bins=256, range=[0, 256], color='navy')
    plt.ylabel("Pixels Distribution", color="darkolivegreen")
    plt.xlabel("Pixel Intensity", color="crimson")

    buf = io.BytesIO()
    plt.savefig(buf, format='jpg')
    buf.seek(0)

    imy = Image.open(buf)

    imy.save('./assets/'+"gray3.png")
    plt.close()


# print("not")


def rgb(src2):
    (B, G, R) = cv2.split(src2)
    plt.hist(x=G.ravel(), bins=256, range=[
             0, 256], color='green', histtype='step')
    plt.hist(x=R.ravel(), bins=256, range=[
             0, 256], color='crimson', histtype='step')
    plt.hist(x=B.ravel(), bins=256, range=[
             0, 256], color='blue', histtype='step')
    plt.title("RGB Distribution")
    plt.ylabel("Pixels Distribution", color="darkolivegreen")
    plt.xlabel("Pixel Intensity", color="crimson")

    b = io.BytesIO()
    plt.savefig(b, format='jpg')
    b.seek(0)

    rgbimage = Image.open(b)

    rgbimage.save('./assets/'+"rgb3.png")
    plt.close()


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True, threaded=True)
    # http_server = WSGIServer(('0.0.0.0', 8000), app)
    # http_server.serve_forever()
