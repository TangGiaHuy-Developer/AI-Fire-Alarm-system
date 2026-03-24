import { Link, useLocation } from "wouter";
import {
  LayoutDashboard,
  LineChart,
  Settings,
  Menu,
} from "lucide-react";
import { motion } from "framer-motion";
import { cn } from "@/lib/utils";
import logo from "@assets/generated_images/logo2.png";

interface SidebarProps {
  collapsed: boolean;
  setCollapsed: (collapsed: boolean) => void;
}

export function Sidebar({ collapsed, setCollapsed }: SidebarProps) {
  const [location] = useLocation();

  const navItems = [
    { icon: LayoutDashboard, label: "Giám sát", href: "/" },
    { icon: LineChart, label: "Phân tích", href: "/analytics" },
    { icon: Settings, label: "Hệ thống", href: "/settings" },
  ];

  return (
    <aside
      className={cn(
        "border-r border-white/10 bg-black/80 backdrop-blur-xl text-foreground flex flex-col h-screen fixed left-0 top-0 z-50 transition-all duration-300 ease-[cubic-bezier(0.25,0.1,0.25,1.0)] shadow-2xl",
        collapsed ? "w-16" : "w-64"
      )}
    >
      {/* Header Logo Area */}
      <div
        className={cn(
          "h-16 flex items-center border-b border-white/5 transition-all",
          collapsed ? "justify-center px-0" : "px-6 gap-3"
        )}
      >
        <div className="h-10 w-10 min-w-[2.5rem] flex items-center justify-center">
          <img 
            src={logo} 
            alt="VHU Logo" 
            className="h-full w-full object-contain"
          />
        </div>
        {!collapsed && (
          <motion.div
            initial={{ opacity: 0, x: -10 }}
            animate={{ opacity: 1, x: 0 }}
            className="overflow-hidden whitespace-nowrap"
          >
            <h1 className="font-bold text-sm tracking-tight uppercase flex items-baseline gap-1.5 bg-gradient-to-r from-white to-white/70 bg-clip-text text-transparent">
              <span>ĐẠI HỌC</span>
              <span className="text-primary text-base">VĂN HIẾN</span>
            </h1>
          </motion.div>
        )}
      </div>

      {/* Navigation */}
      <div className="flex-1 py-6 flex flex-col gap-2 overflow-hidden">
        {!collapsed && (
          <div className="text-[10px] font-bold text-muted-foreground/50 mb-2 px-6 uppercase tracking-[0.2em]">
            Mô-đun Chính
          </div>
        )}
        <nav className="space-y-1 px-3">
          {navItems.map((item) => (
            <Link key={item.href} href={item.href}>
              <div
                className={cn(
                  "flex items-center gap-3 px-3 py-2.5 rounded-md text-sm font-medium transition-all duration-200 cursor-pointer group relative overflow-hidden",
                  location === item.href
                    ? "bg-primary/10 text-primary border border-primary/20 shadow-[inset_0_0_10px_rgba(37,99,235,0.1)]"
                    : "text-muted-foreground hover:text-foreground hover:bg-white/5",
                  collapsed && "justify-center px-2"
                )}
              >
                <item.icon
                  className={cn(
                    "h-5 w-5 min-w-[1.25rem] transition-colors",
                    location === item.href
                      ? "text-primary"
                      : "group-hover:text-foreground"
                  )}
                />

                {!collapsed && (
                  <span className="font-medium tracking-wide">
                    {item.label}
                  </span>
                )}

                {/* Tooltip for collapsed state */}
                {collapsed && (
                  <div className="absolute left-full ml-4 px-3 py-1.5 bg-black/90 border border-white/10 text-white text-xs rounded-md opacity-0 group-hover:opacity-100 pointer-events-none transition-all whitespace-nowrap z-50 shadow-xl translate-x-[-10px] group-hover:translate-x-0">
                    {item.label}
                  </div>
                )}

                {/* Active Indicator for collapsed */}
                {collapsed && location === item.href && (
                  <div className="absolute left-0 top-1/2 -translate-y-1/2 w-0.5 h-8 bg-primary rounded-r-full shadow-[0_0_8px_rgba(37,99,235,0.8)]" />
                )}
              </div>
            </Link>
          ))}
        </nav>
      </div>

      {/* Bottom Toggle Area */}
      <div className="p-3 border-t border-white/5 bg-black/40">
        <button
          onClick={() => setCollapsed(!collapsed)}
          className={cn(
            "w-full flex items-center gap-3 px-3 py-2 text-xs font-medium text-muted-foreground hover:text-primary hover:bg-white/5 rounded-md transition-all cursor-pointer",
            collapsed && "justify-center"
          )}
        >
          <Menu className="h-5 w-5" />
          {!collapsed && <span>Thu gọn Menu</span>}
        </button>
      </div>
    </aside>
  );
}
