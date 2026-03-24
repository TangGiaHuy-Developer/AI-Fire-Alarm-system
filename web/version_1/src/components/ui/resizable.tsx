"use client";

import * as React from "react";
import { cn } from "@/lib/utils";

// Simple Resizable components without complex dependencies
export const ResizablePanelGroup = React.forwardRef<
  HTMLDivElement,
  React.HTMLAttributes<HTMLDivElement> & {
    direction?: "horizontal" | "vertical";
  }
>(({ className, direction = "horizontal", children, ...props }, ref) => {
  return (
    <div
      ref={ref}
      className={cn(
        "flex h-full w-full",
        direction === "vertical" ? "flex-col" : "flex-row",
        className
      )}
      {...props}
    >
      {children}
    </div>
  );
});
ResizablePanelGroup.displayName = "ResizablePanelGroup";

export const ResizablePanel = React.forwardRef<
  HTMLDivElement,
  React.HTMLAttributes<HTMLDivElement> & {
    defaultSize?: number;
  }
>(({ className, defaultSize = 50, children, ...props }, ref) => {
  return (
    <div
      ref={ref}
      className={cn("flex-shrink-0 overflow-hidden", className)}
      style={{ flexBasis: `${defaultSize}%` }}
      {...props}
    >
      {children}
    </div>
  );
});
ResizablePanel.displayName = "ResizablePanel";

export const ResizableHandle = React.forwardRef<
  HTMLDivElement,
  React.HTMLAttributes<HTMLDivElement> & {
    withHandle?: boolean;
  }
>(({ className, withHandle = false, ...props }, ref) => {
  return (
    <div
      ref={ref}
      className={cn(
        "relative flex w-px items-center justify-center bg-border",
        withHandle && "cursor-col-resize hover:bg-primary/50",
        className
      )}
      {...props}
    >
      {withHandle && (
        <div className="z-10 flex h-4 w-3 items-center justify-center rounded-sm border bg-border">
          <div className="h-2.5 w-0.5 bg-muted-foreground" />
        </div>
      )}
    </div>
  );
});
ResizableHandle.displayName = "ResizableHandle";

// export { ResizablePanelGroup, ResizablePanel, ResizableHandle };
