import { useState } from "react";
import { Play, Pause, Maximize2, Camera } from "lucide-react";
import { cn } from "@/lib/utils";

interface RealCameraFeedProps {
  cameraId: string;
  cameraName: string;
  source: number;
  showDetection?: boolean;
}

export function RealCameraFeed({
  cameraId,
  cameraName,
  source,
  showDetection = false,
}: RealCameraFeedProps) {
  const [isPlaying, setIsPlaying] = useState(true);
  const [isFullscreen, setIsFullscreen] = useState(false);

  return (
    <div className="glass-panel rounded-xl overflow-hidden border border-white/5 hover:border-primary/30 transition-all duration-300 hover:shadow-xl hover:shadow-primary/5 group">
      {/* Camera Header */}
      <div className="p-3 border-b border-white/5 bg-black/30 flex items-center justify-between">
        <div className="flex items-center gap-2">
          <Camera className="w-4 h-4 text-primary" />
          <h3 className="font-bold text-sm truncate">{cameraName}</h3>
        </div>
        <div className="flex items-center gap-1">
          <span className="text-[10px] px-2 py-0.5 bg-primary/20 text-primary rounded border border-primary/30">
            TRỰC TIẾP
          </span>
          <button
            onClick={() => setIsPlaying(!isPlaying)}
            className="p-1 rounded hover:bg-white/5 transition-colors"
          >
            {isPlaying ? (
              <Pause className="w-3 h-3" />
            ) : (
              <Play className="w-3 h-3" />
            )}
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
        {/* Simulated Real Camera Feed */}
        <div className="absolute inset-0 flex items-center justify-center">
          <div className="text-center">
            <div className="text-4xl mb-2 animate-pulse">📹</div>
            <p className="text-xs text-gray-400">Đang kết nối camera thực...</p>
            <div className="text-[10px] font-mono mt-2 text-gray-500">
              Source: {source} • Đang stream...
            </div>
          </div>
        </div>

        {/* Detection Overlay */}
        {showDetection && (
          <div
            className="absolute inset-0 border-2 border-red-500 animate-pulse rounded-xl pointer-events-none"
            style={{
              boxShadow: "inset 0 0 20px rgba(239, 68, 68, 0.3)",
            }}
          />
        )}
      </div>

      {/* Camera Footer */}
      <div className="p-3 border-t border-white/5 bg-black/20">
        <div className="flex justify-between items-center text-xs">
          <div className="truncate text-gray-400">
            Camera trực tiếp • Webcam {source}
          </div>
          <div className="font-mono text-[10px] bg-green-500/20 text-green-400 px-1.5 py-0.5 rounded border border-green-500/30">
            ACTIVE
          </div>
        </div>
      </div>
    </div>
  );
}
