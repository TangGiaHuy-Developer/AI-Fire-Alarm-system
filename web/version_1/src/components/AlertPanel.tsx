import { useEffect, useRef, useState } from "react";
import { Flame, AlertTriangle, Info, Bell } from "lucide-react";
import { cn } from "@/lib/utils";
import { useAlertSound } from "@/hooks/useAlertSound";

type EventLog = {
  id: string;
  type: "CRITICAL" | "WARNING" | "INFO";
  message: string;
  timestamp: string;
  camera: string;
  confirmed: "true" | "false" | null;
};

export function AlertPanel() {
  const [logs, setLogs] = useState<EventLog[]>([]);
  const lastId = useRef<string | null>(null);

  const emergencySound = useRef<HTMLAudioElement | null>(null);
  const emergencyPlayed = useRef(false);

  const { playWarning, playCritical, stopAll } = useAlertSound();

  // 🔊 alarm cho cháy thật (kêu 1 lần)
  useEffect(() => {
    emergencySound.current = new Audio("/sounds/alarm.mp3");
    emergencySound.current.volume = 1;
  }, []);

  useEffect(() => {
    const t = setInterval(async () => {
      const res = await fetch("http://localhost:5000/api/events/latest");
      const data: EventLog[] = await res.json();
      if (!data.length) return;

      const newest = data[0];

      if (newest.confirmed) {
        stopAll();
        setLogs(data);
        return;
      }

      if (newest.id !== lastId.current) {
        lastId.current = newest.id;

        emergencyPlayed.current = false; // 🔁 reset cho event mới

        if (newest.type === "WARNING") playWarning();
        if (newest.type === "CRITICAL") playCritical();
        if (newest.type === "INFO") stopAll();
      }

      setLogs(data);
    }, 1000);

    return () => clearInterval(t);
  }, []);

  const confirmTrue = async () => {
    await fetch("http://localhost:5000/api/events/confirm-true", {
      method: "POST",
    });

    stopAll();

    if (!emergencyPlayed.current) {
      emergencySound.current?.play().catch(() => {});
      emergencyPlayed.current = true;
    }
  };

  const confirmFalse = async () => {
    await fetch("http://localhost:5000/api/events/confirm-false", {
      method: "POST",
    });
    stopAll();
  };

  const locked = logs[0]?.confirmed !== null;

  return (
    <div className="h-full flex flex-col border-l">
      <div className="p-4 border-b flex items-center gap-2">
        <Bell size={16} />
        Nhật ký Sự kiện
      </div>

      <div className="flex-1 overflow-auto">
        {logs.map((log) => (
          <div
            key={log.id}
            className={cn(
              "p-3 border-l-4",
              log.type === "CRITICAL"
                ? "border-red-500 bg-red-500/10"
                : log.type === "WARNING"
                ? "border-yellow-400 bg-yellow-400/10"
                : "border-green-500"
            )}
          >
            <div className="text-xs flex justify-between">
              <span>{log.type}</span>
              <span>{log.timestamp}</span>
            </div>

            <p className="text-sm">{log.message}</p>

            <div className="flex gap-2 text-xs mt-1">
              {log.type === "CRITICAL" && <Flame size={12} />}
              {log.type === "WARNING" && <AlertTriangle size={12} />}
              {log.type === "INFO" && <Info size={12} />}
              <span>{log.camera}</span>
            </div>
          </div>
        ))}
      </div>

      <div className="p-3 grid grid-cols-2 gap-2 border-t">
        <button
          disabled={locked}
          onClick={confirmTrue}
          className="bg-red-600 text-white text-xs py-2 rounded disabled:opacity-50"
        >
          BÁO CÁO KHẨN CẤP
        </button>

        <button
          disabled={locked}
          onClick={confirmFalse}
          className="bg-gray-600 text-white text-xs py-2 rounded disabled:opacity-50"
        >
          XÁC NHẬN NHẬN NHẦM
        </button>
      </div>
    </div>
  );
}
