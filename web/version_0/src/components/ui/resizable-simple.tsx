// src/components/ui/resizable-simple.tsx
import * as React from "react";

export const ResizablePanelGroup = ({
  children,
  direction = "horizontal",
}: {
  children: React.ReactNode;
  direction?: "horizontal" | "vertical";
}) => (
  <div
    className={`flex h-full w-full ${
      direction === "vertical" ? "flex-col" : "flex-row"
    }`}
  >
    {children}
  </div>
);

export const ResizablePanel = ({
  children,
  defaultSize = 50,
}: {
  children: React.ReactNode;
  defaultSize?: number;
}) => (
  <div
    className="flex-shrink-0 overflow-hidden"
    style={{ flexBasis: `${defaultSize}%` }}
  >
    {children}
  </div>
);

export const ResizableHandle = ({
  withHandle = false,
}: {
  withHandle?: boolean;
}) => (
  <div
    className={`relative flex w-px items-center justify-center bg-border ${
      withHandle ? "cursor-col-resize" : ""
    }`}
  >
    {withHandle && (
      <div className="z-10 flex h-4 w-3 items-center justify-center rounded-sm border bg-border">
        <div className="h-2.5 w-0.5 bg-muted-foreground" />
      </div>
    )}
  </div>
);
