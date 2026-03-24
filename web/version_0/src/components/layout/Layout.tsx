import { useState } from "react";
import { Sidebar } from "../Sidebar";
import { cn } from "@/lib/utils";

interface LayoutProps {
  children: React.ReactNode;
}

export function Layout({ children }: LayoutProps) {
  const [collapsed, setCollapsed] = useState(true);

  return (
    <div className="flex min-h-screen bg-[#0a0f1c] text-foreground font-sans overflow-hidden selection:bg-primary/30">
      <Sidebar collapsed={collapsed} setCollapsed={setCollapsed} />

      <main
        className={cn(
          "flex-1 flex flex-col h-screen overflow-hidden transition-all duration-300 ease-[cubic-bezier(0.25,0.1,0.25,1.0)]",
          collapsed ? "ml-16" : "ml-64"
        )}
      >
        {children}
      </main>
    </div>
  );
}
