import torch
from torchvision import models

model = models.mobilenet_v2(weights="IMAGENET1K_V1")
model.eval()

example_input = torch.randn(1, 3, 224, 224)

scripted_model = torch.jit.trace(model, example_input)
scripted_model.save("model.pt")

print("Saved model.pt")
