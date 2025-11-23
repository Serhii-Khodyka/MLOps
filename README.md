# Lesson 3 — TorchScript + Docker (FAT & SLIM)

## 1. Export TorchScript model
```bash
python export_model.py
```

## 2. Build Docker images
```bash
docker build -f docker/Dockerfile.fat -t torch-fat .
docker build -f docker/Dockerfile.slim -t torch-slim .
```

## 3. Run inference

### Windows PowerShell (recommended)
Replace the path with your own project directory.

```powershell
docker run --rm -v C:\\Users\\Serhii\\lesson-3\\test_images:/img torch-fat /img/cat.jpg
docker run --rm -v C:\\Users\\Serhii\\lesson-3\\test_images:/img torch-slim /img/cat.jpg
```

### Linux/macOS
```bash
docker run --rm -v ${PWD}/test_images:/img torch-fat /img/cat.jpg
docker run --rm -v ${PWD}/test_images:/img torch-slim /img/cat.jpg
```

## 4. Verify volume mounting (debug)
```powershell
docker run --rm -it -v C:\\Users\\Serhii\\lesson-3\\test_images:/img python:3.10-slim bash
ls /img
```

## 5. Check Docker image layers
```bash
docker history torch-fat
docker history torch-slim
```

## 6. Summary
- FAT image: full environment
- SLIM image: optimized, CPU-only torch
- Both support `/img/<file>` inference