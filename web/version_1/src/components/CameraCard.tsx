import { useEffect, useRef, useState } from "react";
import {
  Play,
  Pause,
  Maximize2,
  Camera,
  Wifi,
  WifiOff,
  AlertTriangle,
  Flame,
} from "lucide-react";
import { cn } from "@/lib/utils";
import { useCameraStatus } from "@/hooks/useCameraStatus";

// interface CameraCardProps {
//   id: string;
//   name: string;
//   status: string;
//   location: string;
//   buildingId?: string;
//   floorId?: string;
//   image?: string;
//   fps?: number;
//   latency?: number;

//   isReal?: boolean;
//   source?: number;
// }

interface CameraCardProps {
  id: string;
  name: string;
  location: string;
  image?: string;

  status: "ok" | "warning" | "critical" | "disconnected";
  fps: number;
  latency: number;

  isReal?: boolean;
}

// export function CameraCard({
//   id,
//   name,
//   status,
//   location,
//   image,
//   fps = 30,
//   latency = 120,
//   isReal = false,
//   source = 0,
// }: CameraCardProps)
export function CameraCard(props: CameraCardProps) {
  const { id, name, location, image, isReal = false } = props;

  const [isPlaying, setIsPlaying] = useState(true);
  const [isFullscreen, setIsFullscreen] = useState(false);

  const realtime = useCameraStatus(id);

  const status = isReal ? realtime.status : props.status;
  const fps = isReal ? realtime.fps : props.fps;
  const latency = isReal ? realtime.latency : props.latency;

  // useEffect(() => {
  //   if (!isReal || !videoRef.current) return;

  //   navigator.mediaDevices
  //     .getUserMedia({ video: true })
  //     .then((stream) => {
  //       videoRef.current!.srcObject = stream;
  //     })
  //     .catch(console.error);

  //   return () => {
  //     const stream = videoRef.current?.srcObject as MediaStream | null;
  //     stream?.getTracks().forEach((t) => t.stop());
  //   };
  // }, [isReal]);

  const getStatusColor = () => {
    switch (status) {
      case "critical":
        return "text-status-critical border-status-critical/30 bg-status-critical/10";
      case "warning":
        return "text-status-warning border-status-warning/30 bg-status-warning/10";
      case "disconnected":
        return "text-gray-500 border-gray-500/30 bg-gray-500/1";
      default:
        return "text-status-ok border-status-ok/30 bg-status-ok/10";
    }
  };

  const getStatusIcon = () => {
    switch (status) {
      case "critical":
        return <Flame className="w-3 h-3" />;
      case "warning":
        return <AlertTriangle className="w-3 h-3" />;
      case "disconnected":
        return <WifiOff className="w-3 h-3" />;
      default:
        return <Wifi className="w-3 h-3" />;
    }
  };

  return (
    <div
      className={cn(
        "glass-panel rounded-xl overflow-hidden border border-white/5 hover:border-primary/30 transition-all duration-300 hover:shadow-xl hover:shadow-primary/5 group",
        isFullscreen ? "fixed inset-4 z-[999] bg-black" : "relative"
      )}
    >
      {/* Camera Header */}
      <div className="p-3 border-b border-white/5 bg-black/30 flex items-center justify-between">
        <div className="flex items-center gap-2">
          <Camera className="w-4 h-4 text-primary" />
          <h3 className="font-bold text-sm truncate">{name}</h3>
        </div>
        <div className="flex items-center gap-1">
          <button
            onClick={() => setIsPlaying(!isPlaying)}
            className="p-1 rounded hover:bg-white/5 transition-colors"
          >
            {/* {isPlaying ? (
              <Pause className="w-3 h-3" />
            ) : (
              <Play className="w-3 h-3" />
            )} */}
          </button>
          <button
            onClick={() => setIsFullscreen(!isFullscreen)}
            className="p-1 rounded hover:bg-white/5 transition-colors"
          >
            <Maximize2 className="w-3 h-3" />
          </button>
        </div>
      </div>
      {/* Camera Feed */}
      <div className="relative aspect-video bg-black">
        {isReal && status !== "disconnected" ? (
          <img
            src={`http://localhost:5000/stream/${id}`}
            alt="camera-stream"
            className={cn(
              "absolute inset-0 w-full h-full object-cover",
              !isPlaying && "blur-sm brightness-75"
            )}
            onError={(e) => {
              // 🔥 nếu stream chết giữa chừng
              (e.currentTarget as HTMLImageElement).style.display = "none";
            }}
          />
        ) : status === "disconnected" ? (
          <div className="absolute inset-0 flex flex-col items-center justify-center text-gray-500">
            <WifiOff className="w-10 h-10 mb-2 opacity-60 animate-pulse" />
            <span className="text-[10px] tracking-widest">DISCONNECTED</span>
          </div>
        ) : image ? (
          <img
            src={image}
            alt={name}
            className={cn(
              "absolute inset-0 w-full h-full object-cover",
              !isPlaying && "blur-sm brightness-75"
            )}
          />
        ) : (
          <div className="absolute inset-0 flex items-center justify-center text-gray-500">
            <Camera className="w-8 h-8 opacity-60" />
          </div>
        )}

        {/* Status Overlay */}
        <div className={cn("", getStatusColor())}>
          {status === "disconnected" ? null : (
            <div
              className={cn(
                "absolute top-2 left-2 px-2 py-1 rounded text-[10px] font-bold flex items-center gap-1 border",
                getStatusColor()
              )}
            >
              {getStatusIcon()}
              {status.toUpperCase()}
            </div>
          )}
        </div>

        {/* Detection Overlay */}
        {(status === "critical" || status === "warning") && (
          <div
            className="absolute inset-0 border-2 animate-pulse rounded-xl pointer-events-none"
            style={{
              borderColor: status === "critical" ? "#ef4444" : "#f59e0b",
              boxShadow: `inset 0 0 20px ${
                status === "critical"
                  ? "rgba(239, 68, 68, 0.3)"
                  : "rgba(245, 158, 11, 0.3)"
              }`,
            }}
          />
        )}
      </div>

      <div className="p-3 border-t border-white/5 bg-black/20">
        <div className="flex justify-between items-center text-xs">
          <div className="truncate text-gray-400">{location}</div>
          <div className="font-mono text-[10px] bg-white/5 px-1.5 py-0.5 rounded">
            ID: {id}
            <div className="flex gap-3 text-[10px] text-gray-400 mt-1">
              <span>FPS: {fps}</span>
              <span>Latency: {latency}ms</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
