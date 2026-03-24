import { useState } from "react";
import { CAMERAS, BUILDINGS } from "@/lib/mockData";
import { Search, SlidersHorizontal, LayoutGrid, Filter, X } from "lucide-react";
import { cn } from "@/lib/utils";
import {
  ResizableHandle,
  ResizablePanel,
  ResizablePanelGroup,
} from "@/components/ui/resizable";

import { AlertPanel } from "../components/AlertPanel";
import { SiteMap } from "../components/SiteMap";
import { CameraCard } from "../components/CameraCard";
// import { RealCameraFeed } from "../components/RealCameraFeed";

export default function DashboardPage() {
  const [selectedBuilding, setSelectedBuilding] = useState<string | null>(null);
  const [selectedFloor, setSelectedFloor] = useState<string | null>(null);

  // Calculate summary stats
  const activeAlerts = CAMERAS.filter((c) => c.status === "critical").length;
  const warnings = CAMERAS.filter((c) => c.status === "warning").length;

  // Filter Cameras
  const filteredCameras = CAMERAS.filter((camera) => {
    if (selectedBuilding && camera.buildingId !== selectedBuilding)
      return false;
    if (selectedFloor && camera.floorId !== selectedFloor) return false;
    return true;
  });

  const handleLocationSelect = (
    buildingId: string | null,
    floorId: string | null
  ) => {
    setSelectedBuilding(buildingId);
    setSelectedFloor(floorId);
  };

  const clearFilters = () => {
    setSelectedBuilding(null);
    setSelectedFloor(null);
  };

  return (
    <div className="flex flex-col h-screen overflow-hidden bg-background text-foreground font-sans">
      <header className="h-16 border-b border-border flex items-center justify-between px-6 bg-card/50 backdrop-blur z-10 shrink-0">
        <div className="flex items-center gap-4">
          <h1 className="text-xl font-bold tracking-tight uppercase font-mono text-primary">
            Trung tâm Điều hành
          </h1>
          <div className="h-6 w-px bg-border mx-2" />
          <div className="flex gap-2">
            <div
              className={cn(
                "px-3 py-1 rounded text-xs font-bold flex items-center gap-2 transition-all",
                activeAlerts > 0
                  ? "bg-status-critical/20 border border-status-critical/50 text-status-critical animate-pulse-slow"
                  : "bg-secondary text-muted-foreground"
              )}
            >
              <span
                className={cn(
                  "w-2 h-2 rounded-full",
                  activeAlerts > 0
                    ? "bg-status-critical animate-ping"
                    : "bg-gray-500"
                )}
              />
              {activeAlerts} NGUY HIỂM
            </div>
            <div
              className={cn(
                "px-3 py-1 rounded text-xs font-bold flex items-center gap-2 transition-all",
                warnings > 0
                  ? "bg-status-warning/20 border border-status-warning/50 text-status-warning"
                  : "bg-secondary text-muted-foreground"
              )}
            >
              <span
                className={cn(
                  "w-2 h-2 rounded-full",
                  warnings > 0 ? "bg-status-warning" : "bg-gray-500"
                )}
              />
              {warnings} CẢNH BÁO
            </div>
          </div>
        </div>

        <div className="flex items-center gap-3">
          <div className="relative group">
            <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground group-focus-within:text-primary transition-colors" />
            <input
              type="text"
              placeholder="Tìm kiếm camera..."
              className="h-9 w-64 pl-9 pr-4 rounded-md bg-secondary/50 border border-border text-sm focus:outline-none focus:ring-1 focus:ring-primary transition-all"
            />
          </div>
          {/* <button className="p-2 rounded-md hover:bg-secondary text-muted-foreground transition-colors">
            <SlidersHorizontal className="h-5 w-5" />
          </button>
          <button className="p-2 rounded-md hover:bg-secondary text-muted-foreground transition-colors">
            <LayoutGrid className="h-5 w-5" />
          </button> */}
        </div>
      </header>

      <div className="flex-1 overflow-hidden">
        <ResizablePanelGroup direction="horizontal">
          <ResizablePanel defaultSize={80}>
            <ResizablePanelGroup direction="vertical">
              {/* Map Panel */}
              <ResizablePanel defaultSize={40}>
                <div className="h-full w-full p-4 bg-black/20">
                  <SiteMap
                    selectedBuilding={selectedBuilding}
                    selectedFloor={selectedFloor}
                    onSelectLocation={handleLocationSelect}
                  />
                </div>
              </ResizablePanel>

              <ResizableHandle withHandle />

              <ResizablePanel defaultSize={60}>
                <div className="h-full w-full overflow-y-auto p-6 bg-background/50">
                  <div className="flex items-center justify-between mb-6">
                    <h2 className="font-bold text-lg flex items-center gap-2">
                      <Filter className="w-4 h-4 text-primary" />
                      {selectedBuilding
                        ? `Camera tại ${
                            BUILDINGS.find((b) => b.id === selectedBuilding)
                              ?.name
                          }`
                        : "Tất cả Camera Hệ thống"}
                      {selectedFloor && (
                        <span className="text-muted-foreground font-normal">
                          /{" "}
                          {
                            BUILDINGS.find(
                              (b) => b.id === selectedBuilding
                            )?.floors.find((f) => f.id === selectedFloor)?.name
                          }
                        </span>
                      )}
                    </h2>

                    {(selectedBuilding || selectedFloor) && (
                      <button
                        onClick={clearFilters}
                        className="text-xs flex items-center gap-1 text-muted-foreground hover:text-destructive transition-colors"
                      >
                        <X className="w-3 h-3" /> Xóa bộ lọc
                      </button>
                    )}
                  </div>

                  <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 2xl:grid-cols-4 gap-6 pb-20">
                    {/* <RealCameraFeed
                      cameraId="real-camera-1"
                      cameraName="Webcam 1 (Fire Detection)"
                      source={0}
                      showDetection={true}
                    /> */}

                    {/* <CameraCard
                      id="cam1"
                      name="Fire Cam"
                      location="Warehouse A"
                      isReal
                    />

                    {filteredCameras.length > 0 ? (
                      filteredCameras.map((camera) => (
                        <CameraCard key={camera.id} {...camera} />
                      ))
                    ) : (
                      <div className="col-span-full h-40 flex items-center justify-center border-2 border-border rounded-lg text-muted-foreground">
                        Không tìm thấy camera nào tại vị trí này.
                      </div>
                    )} */}
                    <CameraCard
                      id="cam1"
                      name="Camera Realtime"
                      location="Nhà riêng"
                      isReal
                      status="ok"
                      fps={0}
                      latency={0}
                    />

                    {filteredCameras.length > 0 ? (
                      filteredCameras.map((camera) => (
                        <CameraCard
                          key={camera.id}
                          id={camera.id}
                          name={camera.name}
                          location={camera.location}
                          image={camera.image}
                          status={
                            camera.status === "critical"
                              ? "critical"
                              : camera.status === "warning"
                              ? "warning"
                              : camera.status === "ok"
                              ? "ok"
                              : "disconnected"
                          }
                          fps={camera.fps ?? 0}
                          latency={camera.latency ?? 0}
                          isReal={false}
                        />
                      ))
                    ) : (
                      <div className="col-span-full h-40 flex items-center justify-center border-2 border-border rounded-lg text-muted-foreground">
                        Không tìm thấy camera nào tại vị trí này.
                      </div>
                    )}

                    <div className="w-full h-full aspect-video rounded-lg border-2 border-border flex flex-col items-center justify-center text-muted-foreground hover:text-primary hover:border-primary/50 hover:bg-primary/5 transition-all cursor-pointer group opacity-50 hover:opacity-100">
                      <div className="w-12 h-12 rounded-full bg-secondary group-hover:bg-primary/20 flex items-center justify-center mb-3 transition-colors">
                        <span className="text-2xl">+</span>
                      </div>
                      <span className="text-sm font-medium">
                        Thêm nguồn mới
                      </span>
                    </div>
                  </div>
                </div>
              </ResizablePanel>
            </ResizablePanelGroup>
          </ResizablePanel>

          <ResizableHandle withHandle />

          <ResizablePanel
            defaultSize={20}
            className="hidden xl:block bg-card border-l border-border"
          >
            <AlertPanel />
          </ResizablePanel>
        </ResizablePanelGroup>
      </div>
    </div>
  );
}
