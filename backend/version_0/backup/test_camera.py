import cv2
import sys

def test_camera():
    print("Testing camera...")
    
    # Try different camera indices
    for i in range(5):
        cap = cv2.VideoCapture(i)
        if cap.isOpened():
            print(f"✓ Camera found at index {i}")
            
            # Get properties
            width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
            height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
            fps = int(cap.get(cv2.CAP_PROP_FPS)) if cap.get(cv2.CAP_PROP_FPS) > 0 else 0
            
            print(f"  Resolution: {width}x{height}")
            print(f"  FPS: {fps}")
            
            # Try to read a frame
            ret, frame = cap.read()
            if ret:
                print(f"  ✓ Can read frames")
                cv2.imwrite(f"camera_test_{i}.jpg", frame)
            else:
                print(f"  ✗ Cannot read frames")
            
            cap.release()
        else:
            print(f"✗ No camera at index {i}")
    
    print("\nCamera test complete!")

if __name__ == "__main__":
    test_camera()