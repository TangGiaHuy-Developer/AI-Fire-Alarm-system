// lib/cameraService.ts
class CameraService {
  private socket: WebSocket | null = null;
  private callbacks: Map<string, Function> = new Map();

  connect(cameraId: string, source: number | string = 0) {
    // Connect to Python backend WebSocket
    const wsUrl = `ws://localhost:8000/ws/camera/${cameraId}`;
    this.socket = new WebSocket(wsUrl);

    this.socket.onopen = () => {
      console.log(`Connected to camera ${cameraId}`);
      // Send camera source configuration
      this.socket?.send(JSON.stringify({
        source: source,  // 0 for default webcam, or RTSP URL
        processing: true
      }));
    };

    this.socket.onmessage = (event) => {
      const data = JSON.parse(event.data);
      
      if (data.type === 'frame') {
        // Trigger frame callback
        this.triggerCallback('onFrame', data);
      } else if (data.type === 'alert') {
        // Trigger alert callback
        this.triggerCallback('onAlert', data);
      } else if (data.error) {
        console.error('Camera error:', data.error);
      }
    };

    this.socket.onerror = (error) => {
      console.error('WebSocket error:', error);
    };

    this.socket.onclose = () => {
      console.log(`Disconnected from camera ${cameraId}`);
    };
  }

  disconnect() {
    if (this.socket) {
      this.socket.close();
      this.socket = null;
    }
  }

  on(event: string, callback: Function) {
    this.callbacks.set(event, callback);
  }

  private triggerCallback(event: string, data: any) {
    const callback = this.callbacks.get(event);
    if (callback) {
      callback(data);
    }
  }
}

export const cameraService = new CameraService();