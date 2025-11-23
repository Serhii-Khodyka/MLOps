import torch
from PIL import Image
from torchvision import transforms
import sys

# Load TorchScript model
model = torch.jit.load("model.pt")
model.eval()

# Correct ImageNet preprocessing
preprocess = transforms.Compose([
    transforms.Resize(256),
    transforms.CenterCrop(224),
    transforms.ToTensor(),

    # *** IMPORTANT: ImageNet normalization ***
    transforms.Normalize(
        mean=[0.485, 0.456, 0.406],
        std=[0.229, 0.224, 0.225]
    )
])

def infer(img_path):
    img = Image.open(img_path).convert("RGB")
    tensor = preprocess(img).unsqueeze(0)

    with torch.no_grad():
        preds = model(tensor)[0]

    top3 = torch.topk(preds, 3)

    print("Top-3 predictions:")
    for score, idx in zip(top3.values, top3.indices):
        print(f"Class index: {idx.item()}, Score: {float(score):.4f}")


if __name__ == "__main__":
    infer(sys.argv[1])
