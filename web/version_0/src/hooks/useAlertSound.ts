import { useRef } from "react";

export function useAlertSound() {
  const warning = useRef<HTMLAudioElement | null>(null);
  const critical = useRef<HTMLAudioElement | null>(null);

  if (!warning.current) {
    warning.current = new Audio("/sounds/warning.mp3");
    warning.current.volume = 0.4;
  }

  if (!critical.current) {
    critical.current = new Audio("/sounds/critical.mp3");
    critical.current.loop = true;
    critical.current.volume = 0.7;
  }

  const stopAll = () => {
    [warning.current, critical.current].forEach((a) => {
      if (a) {
        a.pause();
        a.currentTime = 0;
      }
    });
  };

  return {
    playWarning: () => {
      stopAll(); // 🔴 NGẮT NGAY ÂM KHÁC
      warning.current?.play().catch(() => {});
    },

    playCritical: () => {
      stopAll(); // 🔴 NGẮT NGAY ÂM KHÁC
      critical.current?.play().catch(() => {});
    },

    stopAll, // dùng khi confirm / reset
  };
}
