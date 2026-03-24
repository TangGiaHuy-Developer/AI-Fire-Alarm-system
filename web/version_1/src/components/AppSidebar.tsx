import {
  Sidebar,
  SidebarContent,
  SidebarFooter,
  SidebarHeader,
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
} from "@/components/ui/sidebar";

import { navItems } from "@/constants/nav";

export function AppSidebar() {
  return (
    <Sidebar collapsible="icon">
      <SidebarHeader className="px-4 py-3 text-lg font-bold">
        🔥 Fire & Smoke
      </SidebarHeader>

      <SidebarContent>
        <SidebarMenu>
          {navItems.map((item) => {
            const Icon = item.icon;

            return (
              <SidebarMenuItem key={item.label}>
                <SidebarMenuButton className="flex items-center gap-3">
                  <Icon className="h-4 w-4" />
                  {item.label}
                </SidebarMenuButton>
              </SidebarMenuItem>
            );
          })}
        </SidebarMenu>
      </SidebarContent>

      <SidebarFooter className="px-4 py-2 text-sm text-muted-foreground">
        NCKH 2025
      </SidebarFooter>
    </Sidebar>
  );
}
