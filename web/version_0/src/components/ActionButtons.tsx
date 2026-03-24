import React from "react";

const ActionButtons: React.FC = () => {
  const actions = [
    {
      label: "Thêm Camera",
      icon: "➕",
      color: "bg-blue-500 hover:bg-blue-600",
    },
    {
      label: "Xuất Báo cáo",
      icon: "📊",
      color: "bg-green-500 hover:bg-green-600",
    },
    {
      label: "Cảnh báo",
      icon: "⚠️",
      color: "bg-yellow-500 hover:bg-yellow-600",
    },
    {
      label: "Cài đặt Hệ thống",
      icon: "⚙️",
      color: "bg-gray-500 hover:bg-gray-600",
    },
  ];

  return (
    <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
      {actions.map((action, index) => (
        <button
          key={index}
          className={`${action.color} text-white rounded-lg p-4 flex flex-col items-center justify-center transition-colors`}
        >
          <span className="text-2xl mb-2">{action.icon}</span>
          <span className="text-sm font-medium">{action.label}</span>
        </button>
      ))}
    </div>
  );
};

export default ActionButtons;
