import React from "react";

const Header: React.FC = () => {
  return (
    <header className="bg-white border-b border-gray-200 px-6 py-4">
      <div className="flex justify-between items-center">
        <div>
          <h2 className="text-2xl font-bold text-gray-800">
            Tất cả Camera Hệ thống
          </h2>
          <p className="text-gray-600 text-sm">
            Quản lý và giám sát tất cả camera
          </p>
        </div>

        <div className="flex items-center space-x-4">
          <button className="bg-blue-500 text-white px-4 py-2 rounded-md hover:bg-blue-600">
            ↻ Refresh
          </button>
          <div className="relative">
            <div className="w-8 h-8 bg-gray-300 rounded-full flex items-center justify-center">
              <span className="text-gray-600">👤</span>
            </div>
          </div>
        </div>
      </div>
    </header>
  );
};

export default Header;
