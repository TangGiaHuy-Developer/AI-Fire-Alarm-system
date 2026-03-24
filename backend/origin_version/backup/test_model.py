import torch
import sys
import os

def test_model():
    print("Testing model file...")
    
    model_path = "models/weights/best.pt"
    
    if not os.path.exists(model_path):
        print(f"✗ Model file not found at: {model_path}")
        print(f"  Current directory: {os.getcwd()}")
        print(f"  Please download the model and place it at: {model_path}")
        return False
    
    print(f"✓ Model file exists: {model_path}")
    print(f"  File size: {os.path.getsize(model_path) / (1024*1024):.2f} MB")
    
    # Try to load with PyTorch
    try:
        # Try with weights_only=False
        checkpoint = torch.load(model_path, map_location='cpu', weights_only=False)
        print("✓ Can load model with torch.load")
        
        # Check keys
        print(f"  Checkpoint keys: {list(checkpoint.keys())}")
        
        # Check for model architecture
        if 'model' in checkpoint:
            print(f"  Model parameters: {sum(p.numel() for p in checkpoint['model'].parameters()):,}")
        
        return True
    except Exception as e:
        print(f"✗ Error loading model: {e}")
        return False

if __name__ == "__main__":
    test_model()