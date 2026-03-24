import React from "react";

const MapPanel: React.FC = () => {
  const floors = [
    { name: "Tầng 1", cameras: 10 },
    { name: "Tầng 2", cameras: 8 },
    { name: "Tầng 3", cameras: 12 },
    { name: "Tầng 4", cameras: 6 },
    { name: "Tầng 5", cameras: 9 },
  ];

  return (
    <div className="bg-white rounded-lg shadow p-4">
      <h3 className="font-semibold text-lg mb-4">Bãi xe - Sơ đồ</h3>
      <div className="grid grid-cols-5 gap-2 mb-4">
        {floors.map((floor) => (
          <div
            key={floor.name}
            className="bg-blue-50 border border-blue-200 rounded p-2 text-center"
          >
            <div className="font-medium">{floor.name}</div>
            <div className="text-sm text-blue-600">{floor.cameras} cameras</div>
          </div>
        ))}
      </div>
      <div className="border border-gray-200 rounded p-3 h-48 flex items-center justify-center bg-gray-50 text-red-200">
        <div className="text-center text-gray-500">
          <div className="text-2xl mb-2">🗺️</div>
          <p>Interactive Map View</p>
          <p className="text-sm">Click để xem chi tiết từng tầng</p>
        </div>
      </div>
    </div>
  );
};

export default MapPanel;
