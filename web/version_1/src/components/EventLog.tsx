import React from "react";

const EventLog: React.FC = () => {
  const events = [
    { time: "10:23", camera: "B15", event: "Motion Detected", type: "motion" },
    { time: "09:45", camera: "B07", event: "Camera Offline", type: "error" },
    {
      time: "09:12",
      camera: "B22",
      event: "Vehicle Detected",
      type: "vehicle",
    },
    { time: "08:30", camera: "B01", event: "Person Detected", type: "person" },
    { time: "08:15", camera: "B33", event: "Connection Lost", type: "error" },
  ];

  const getEventColor = (type: string) => {
    switch (type) {
      case "error":
        return "text-red-600 bg-red-50";
      case "motion":
        return "text-yellow-600 bg-yellow-50";
      case "vehicle":
        return "text-blue-600 bg-blue-50";
      case "person":
        return "text-green-600 bg-green-50";
      default:
        return "text-gray-600 bg-gray-50";
    }
  };

  return (
    <div className="bg-white rounded-lg shadow p-4">
      <h3 className="font-semibold text-lg mb-4">Event Log</h3>
      <div className="space-y-3">
        {events.map((event, index) => (
          <div
            key={index}
            className="flex items-center p-2 border border-gray-100 rounded hover:bg-gray-50"
          >
            <div className="w-10 text-center">
              <div className="font-mono text-sm">{event.time}</div>
            </div>
            <div className="mx-4 w-12 text-center font-semibold">
              {event.camera}
            </div>
            <div className="flex-1">
              <span
                className={`px-2 py-1 rounded text-xs ${getEventColor(
                  event.type
                )}`}
              >
                {event.event}
              </span>
            </div>
            <button className="text-gray-400 hover:text-gray-600">⋮</button>
          </div>
        ))}
      </div>
      <button className="w-full mt-4 text-center text-blue-600 text-sm py-2 border border-blue-200 rounded hover:bg-blue-50">
        Xem tất cả sự kiện
      </button>
    </div>
  );
};

export default EventLog;
