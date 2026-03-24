import { useEffect, useState } from "react";

type CameraStatus = "ok" | "warning" | "critical" | "disconnected";

export function useCameraStatus(cameraId: string) {
  const [data, setData] = useState<{
    status: CameraStatus;
    fps: number;
    latency: number;
  }>({
    status: "disconnected",
    fps: 0,
    latency: 0,
  });

  useEffect(() => {
    let alive = true;

    const fetchStatus = async () => {
      const t0 = performance.now();

      try {
        const res = await fetch(`http://localhost:5000/detection/${cameraId}`, {
          cache: "no-store",
        });

        if (!res.ok) throw new Error("backend down");

        const json = await res.json();
        const t1 = performance.now();

        if (!alive) return;

        let status: CameraStatus = "disconnected";

        switch (json.alert_level) {
          case "critical":
            status = "critical";
            break;
          case "warning":
            status = "warning";
            break;
          case "normal":
          case "ok":
            status = "ok";
            break;
          default:
            status = "disconnected";
        }

        setData({
          status,
          fps: json.fps ?? 0,
          latency: Math.round(t1 - t0),
        });
      } catch {
        if (!alive) return;
        setData({
          status: "disconnected",
          fps: 0,
          latency: 0,
        });
      }
    };

    fetchStatus();
    const i = setInterval(fetchStatus, 1000);

    return () => {
      alive = false;
      clearInterval(i);
    };
  }, [cameraId]);

  return data;
}
