import { useState, useEffect } from "react";
import { MapContainer, TileLayer, Marker, Popup, useMap } from "react-leaflet";
import { motion, AnimatePresence } from "framer-motion";
import { cn } from "@/lib/utils";
import { CAMERAS } from "@/lib/mockData";
import {
  Layers,
  AlertTriangle,
  Flame,
  Maximize2,
  Minimize2,
  Navigation,
  Camera,
  WifiOff,
} from "lucide-react";
import L from "leaflet";

// Fix for default marker icon in React-Leaflet
delete (L.Icon.Default.prototype as any)._getIconUrl;
L.Icon.Default.mergeOptions({
  iconRetinaUrl:
    "https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon-2x.png",
  iconUrl: "https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png",
  shadowUrl: "https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png",
});

interface SiteMapProps {
  selectedBuilding: string | null;
  selectedFloor: string | null;
  onSelectLocation: (buildingId: string | null, floorId: string | null) => void;
}

// Component to handle map flyTo animation
function MapUpdater({
  center,
  zoom,
}: {
  center: [number, number];
  zoom: number;
}) {
  const map = useMap();
  useEffect(() => {
    map.flyTo(center, zoom, { duration: 1.5 });
  }, [center, zoom, map]);
  return null;
}

export function SiteMap({
  selectedBuilding,
  selectedFloor,
  onSelectLocation,
}: SiteMapProps) {
  const [isExpanded, setIsExpanded] = useState(false);

  // Default center (Saigon High Tech Park approx)
  const defaultCenter: [number, number] = [10.8545, 106.7998];
  const defaultZoom = 16;

  const activeCamera = CAMERAS.find((c) => c.buildingId === selectedBuilding);
  const center: [number, number] =
    activeCamera && activeCamera.lat && activeCamera.lng
      ? [activeCamera.lat, activeCamera.lng]
      : defaultCenter;

  const zoom = selectedBuilding ? 18 : defaultZoom;

  const createCustomIcon = (status: string, isSelected: boolean) => {
    const size = isSelected ? 32 : 24;
    const iconSize: [number, number] = [size, size];
    const iconAnchor: [number, number] = [size / 2, size];
    const popupAnchor: [number, number] = [0, -size];

    let html = "";
    let markerClass = "";

    switch (status) {
      case "critical":
        markerClass = "marker-critical";
        html = `        
          <div class="relative w-full h-full flex items-center justify-center">
            <div class="absolute inset-0 bg-red-500 rounded-full animate-ping opacity-75"></div>
            <div class="relative w-4 h-4 bg-red-600 border-2 border-white rounded-full shadow-[0_0_15px_rgba(220,38,38,0.9)]"></div>
          </div>
        `;
        break;
      case "warning":
        markerClass = "marker-warning";
        html = `
          <div class="relative w-full h-full flex items-center justify-center">
            <div class="absolute inset-0 bg-yellow-500 rounded-full animate-pulse opacity-50"></div>
            <div class="relative w-4 h-4 bg-yellow-500 border-2 border-white rounded-full shadow-[0_0_15px_rgba(234,179,8,0.9)]"></div>
          </div>
        `;
        break;
      case "disconnected":
        markerClass = "disconnected-marker";
        html = `
          <div class="relative w-full h-full flex items-center justify-center">
            <div class="relative w-4 h-4 bg-gray-500 border-2 border-white rounded-full"></div>
            <div class="absolute -top-2 -right-2 text-gray-400 text-[10px] font-bold bg-white rounded-full w-4 h-4 flex items-center justify-center">!</div>
          </div>
        `;
        break;
      default:
        markerClass = "ok-marker";
        html = `
          <div class="relative w-full h-full flex items-center justify-center">
            <div class="w-3 h-3 ${
              isSelected ? "bg-primary scale-150" : "bg-blue-500"
            } border-2 border-white rounded-full shadow-lg transition-all duration-300"></div>
          </div>
        `;
    }

    return L.divIcon({
      html: html,
      className: `custom-marker-icon custom-marker ${markerClass} ${
        isSelected ? "selected-marker" : ""
      }`,
      iconSize: iconSize,
      iconAnchor: iconAnchor,
      popupAnchor: popupAnchor,
    });
  };

  return (
    <div className="w-full h-full relative group">
      {/* Main Map Container */}
      <div
        className={cn(
          "w-full h-full bg-black rounded-xl overflow-hidden relative z-0 transition-all duration-500",
          isExpanded ? "fixed inset-0 z-50 m-0 rounded-none" : "relative"
        )}
      >
        {/* Controls */}
        <div className="absolute top-3 right-3 z-[1000] flex gap-2 pointer-events-auto">
          <button
            onClick={() => setIsExpanded(!isExpanded)}
            className="p-2 bg-black/80 backdrop-blur hover:bg-primary text-white rounded-lg transition-colors border border-white/10 shadow-lg"
          >
            {isExpanded ? (
              <Minimize2 className="w-4 h-4" />
            ) : (
              <Maximize2 className="w-4 h-4" />
            )}
          </button>
        </div>

        <div className="absolute top-3 left-3 z-[1000] bg-black/80 backdrop-blur px-3 py-1.5 rounded-lg border border-white/10 flex items-center gap-2 shadow-lg pointer-events-auto">
          <Navigation className="w-3 h-3 text-primary" />
          <span className="text-xs font-mono font-bold tracking-wider text-white">
            HỆ THỐNG ĐỊA LÝ
          </span>
        </div>

        {/* Legend */}
        <div className="absolute bottom-3 left-3 z-[1000] bg-black/80 backdrop-blur px-3 py-2 rounded-lg border border-white/10 shadow-lg pointer-events-auto">
          <div className="flex flex-col gap-1.5">
            <div className="flex items-center gap-2 text-[10px] text-white">
              <span className="w-2 h-2 rounded-full bg-red-500 animate-pulse"></span>{" "}
              Nguy hiểm
            </div>
            <div className="flex items-center gap-2 text-[10px] text-white">
              <span className="w-2 h-2 rounded-full bg-yellow-500"></span> Cảnh
              báo
            </div>
            <div className="flex items-center gap-2 text-[10px] text-white">
              <span className="w-2 h-2 rounded-full bg-blue-500"></span> Hoạt
              động
            </div>
            <div className="flex items-center gap-2 text-[10px] text-white">
              <span className="w-2 h-2 rounded-full bg-gray-500"></span> Mất tín
              hiệu
            </div>
          </div>
        </div>

        {/* Leaflet Map Container - THÊM CLASSNAME FIX */}
        <div className="w-full h-full relative">
          {" "}
          <MapContainer
            center={defaultCenter}
            zoom={defaultZoom}
            style={{ height: "100%", width: "100%", position: "relative" }}
            zoomControl={false}
            attributionControl={false}
            className="leaflet-map-container"
          >
            {/* Dark Matter Tile Layer for Tech Look */}
            <TileLayer
              url="https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png"
              attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors &copy; <a href="https://carto.com/attributions">CARTO</a>'
            />

            <MapUpdater center={center} zoom={zoom} />

            {CAMERAS.map((camera) => {
              // Only render cameras that have coordinates
              if (!camera.lat || !camera.lng) return null;

              const isSelected = selectedBuilding === camera.buildingId;

              return (
                <Marker
                  key={camera.id}
                  position={[camera.lat, camera.lng]}
                  icon={createCustomIcon(camera.status, isSelected)}
                  eventHandlers={{
                    click: () => {
                      onSelectLocation(
                        camera.buildingId || null,
                        camera.floorId || null
                      );
                    },
                  }}
                >
                  <Popup className="custom-popup-dark " closeButton={false}>
                    <div className="p-2 min-w-[200px] bg-card/85 backdrop-blur-md rounded-lg">
                      <div className="flex items-center justify-between mb-2 border-b border-gray-700 pb-1">
                        <h3 className="font-bold text-sm text-white flex items-center gap-1">
                          <Camera className="w-3 h-3" /> {camera.name}
                        </h3>
                        {camera.status !== "ok" && (
                          <div
                            className={cn(
                              "px-1.5 py-0.5 rounded text-[10px] font-bold text-white uppercase flex items-center gap-1 ",
                              camera.status === "critical"
                                ? "bg-red-600 animate-pulse"
                                : camera.status === "warning"
                                ? "bg-yellow-500"
                                : "bg-gray-500"
                            )}
                          >
                            {camera.status === "critical" && (
                              <Flame className="w-3 h-3" />
                            )}
                            {camera.status === "disconnected" && (
                              <WifiOff className="w-3 h-3" />
                            )}
                            {camera.status}
                          </div>
                        )}
                      </div>

                      <div className="text-xs text-gray-300 space-y-1">
                        <p>
                          Vị trí:{" "}
                          <span className="font-semibold">
                            {camera.location}
                          </span>
                        </p>
                        <p>
                          Trạng thái:{" "}
                          <span className="font-semibold uppercase">
                            {camera.status}
                          </span>
                        </p>
                        {camera.fps > 0 && (
                          <p>
                            FPS: {camera.fps} | Latency: {camera.latency}ms
                          </p>
                        )}
                      </div>
                    </div>
                  </Popup>
                </Marker>
              );
            })}
          </MapContainer>
        </div>
      </div>
    </div>
  );
}
