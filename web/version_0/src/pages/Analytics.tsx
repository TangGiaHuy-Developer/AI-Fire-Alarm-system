import { useState } from "react";
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip as RechartsTooltip,
  Legend,
  ResponsiveContainer,
  LineChart,
  Line,
  AreaChart,
  Area,
} from "recharts";
import { ANALYTICS_DATA, MOCK_LOGS, CAMERAS } from "@/lib/mockData";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import {
  AlertTriangle,
  CheckCircle,
  Clock,
  Activity,
  FileText,
  Download,
  Server,
  Shield,
  Eye,
  AlertCircle,
  WifiOff,
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";

export default function Analytics() {
  const [activeTab, setActiveTab] = useState("overview");

  // System Stats
  const totalCameras = CAMERAS.length;
  const activeCameras = CAMERAS.filter(
    (c) => c.status !== "disconnected"
  ).length;
  const criticalEvents = MOCK_LOGS.filter((l) => l.type === "CRITICAL").length;
  const avgConfidence = 94.5;

  return (
    <div className="flex flex-col h-full overflow-hidden bg-background text-foreground font-sans animate-in fade-in duration-500">
      <header className="h-16 border-b border-border flex items-center justify-between px-6 bg-card/50 backdrop-blur shrink-0">
        <div>
          <h1 className="text-2xl font-bold tracking-tight flex items-center gap-2">
            <Activity className="w-6 h-6 text-primary" />
            Báo cáo & Phân tích
          </h1>
          <p className="text-xs text-muted-foreground">
            Hệ thống Giám sát PCCC Thông minh
          </p>
        </div>
        <div className="flex gap-2">
          <Button variant="outline" size="sm" className="h-8">
            <Clock className="w-4 h-4 mr-2" /> 24 Giờ qua
          </Button>
          <Button
            variant="default"
            size="sm"
            className="h-8 shadow-lg shadow-primary/20"
          >
            <Download className="w-4 h-4 mr-2" /> Xuất Báo cáo PDF
          </Button>
        </div>
      </header>

      <main className="flex-1 overflow-y-auto p-6 scroll-smooth">
        <Tabs
          defaultValue="overview"
          className="space-y-6"
          onValueChange={setActiveTab}
        >
          <TabsList className="grid w-full grid-cols-3 lg:w-[400px] bg-muted/50 p-1">
            <TabsTrigger value="overview">Tổng quan</TabsTrigger>
            <TabsTrigger value="performance">Hiệu năng AI</TabsTrigger>
            <TabsTrigger value="logs">Nhật ký Hệ thống</TabsTrigger>
          </TabsList>

          <TabsContent value="overview" className="space-y-6">
            {/* Stats Cards */}
            <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
              <Card className="bg-card/50 backdrop-blur border-white/5 shadow-lg">
                <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                  <CardTitle className="text-sm font-medium">
                    Camera Hoạt động
                  </CardTitle>
                  <Eye className="h-4 w-4 text-muted-foreground" />
                </CardHeader>
                <CardContent>
                  <div className="text-2xl font-bold">
                    {activeCameras}/{totalCameras}
                  </div>
                  <p className="text-xs text-muted-foreground flex items-center gap-1 mt-1">
                    {totalCameras - activeCameras > 0 ? (
                      <span className="text-destructive flex items-center">
                        <WifiOff className="w-3 h-3 mr-1" />{" "}
                        {totalCameras - activeCameras} mất kết nối
                      </span>
                    ) : (
                      <span className="text-green-500 flex items-center">
                        <CheckCircle className="w-3 h-3 mr-1" /> Tất cả ổn định
                      </span>
                    )}
                  </p>
                </CardContent>
              </Card>
              <Card className="bg-card/50 backdrop-blur border-white/5 shadow-lg">
                <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                  <CardTitle className="text-sm font-medium">
                    Cảnh báo Nguy hiểm
                  </CardTitle>
                  <AlertTriangle className="h-4 w-4 text-red-500" />
                </CardHeader>
                <CardContent>
                  <div className="text-2xl font-bold text-red-500 animate-pulse">
                    {criticalEvents}
                  </div>
                  <p className="text-xs text-muted-foreground mt-1">
                    +2 so với tuần trước
                  </p>
                </CardContent>
              </Card>
              <Card className="bg-card/50 backdrop-blur border-white/5 shadow-lg">
                <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                  <CardTitle className="text-sm font-medium">
                    Độ Chính xác AI
                  </CardTitle>
                  <Activity className="h-4 w-4 text-blue-500" />
                </CardHeader>
                <CardContent>
                  <div className="text-2xl font-bold text-blue-500">
                    {avgConfidence}%
                  </div>
                  <p className="text-xs text-muted-foreground mt-1">
                    Tăng 2.5% sau đợt huấn luyện mới
                  </p>
                </CardContent>
              </Card>
              <Card className="bg-card/50 backdrop-blur border-white/5 shadow-lg">
                <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                  <CardTitle className="text-sm font-medium">
                    Thời gian Hoạt động
                  </CardTitle>
                  <Server className="h-4 w-4 text-green-500" />
                </CardHeader>
                <CardContent>
                  <div className="text-2xl font-bold text-green-500">99.9%</div>
                  <p className="text-xs text-muted-foreground mt-1">
                    Hệ thống ổn định
                  </p>
                </CardContent>
              </Card>
            </div>

            <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-7">
              <Card className="col-span-4 bg-card/50 backdrop-blur border-white/5 shadow-lg">
                <CardHeader>
                  <CardTitle>
                    Biểu đồ Độ chính xác & Cảnh báo sai (False Alarm)
                  </CardTitle>
                  <CardDescription>
                    So sánh hiệu quả mô hình qua các tuần thực nghiệm
                  </CardDescription>
                </CardHeader>
                <CardContent className="pl-2">
                  <ResponsiveContainer width="100%" height={350}>
                    <AreaChart data={ANALYTICS_DATA}>
                      <defs>
                        <linearGradient
                          id="colorAccuracy"
                          x1="0"
                          y1="0"
                          x2="0"
                          y2="1"
                        >
                          <stop
                            offset="5%"
                            stopColor="hsl(var(--primary))"
                            stopOpacity={0.8}
                          />
                          <stop
                            offset="95%"
                            stopColor="hsl(var(--primary))"
                            stopOpacity={0}
                          />
                        </linearGradient>
                        <linearGradient
                          id="colorFalse"
                          x1="0"
                          y1="0"
                          x2="0"
                          y2="1"
                        >
                          <stop
                            offset="5%"
                            stopColor="hsl(var(--destructive))"
                            stopOpacity={0.8}
                          />
                          <stop
                            offset="95%"
                            stopColor="hsl(var(--destructive))"
                            stopOpacity={0}
                          />
                        </linearGradient>
                      </defs>
                      <XAxis
                        dataKey="name"
                        stroke="#888888"
                        fontSize={12}
                        tickLine={false}
                        axisLine={false}
                      />
                      <YAxis
                        stroke="#888888"
                        fontSize={12}
                        tickLine={false}
                        axisLine={false}
                        tickFormatter={(value) => `${value}%`}
                      />
                      <CartesianGrid
                        strokeDasharray="3 3"
                        className="stroke-muted"
                        vertical={false}
                      />
                      <RechartsTooltip
                        contentStyle={{
                          backgroundColor: "hsl(var(--card))",
                          borderColor: "hsl(var(--border))",
                          borderRadius: "8px",
                        }}
                        itemStyle={{ color: "hsl(var(--foreground))" }}
                      />
                      <Legend />
                      <Area
                        type="monotone"
                        dataKey="accuracy"
                        name="Độ chính xác (%)"
                        stroke="hsl(var(--primary))"
                        fillOpacity={1}
                        fill="url(#colorAccuracy)"
                        strokeWidth={3}
                      />
                      <Area
                        type="monotone"
                        dataKey="falsePositives"
                        name="Tỷ lệ báo sai (%)"
                        stroke="hsl(var(--destructive))"
                        fillOpacity={1}
                        fill="url(#colorFalse)"
                        strokeWidth={3}
                      />
                    </AreaChart>
                  </ResponsiveContainer>
                </CardContent>
              </Card>

              <Card className="col-span-3 bg-card/50 backdrop-blur border-white/5 shadow-lg">
                <CardHeader>
                  <CardTitle>Phân bổ Sự kiện</CardTitle>
                  <CardDescription>
                    Phân loại các cảnh báo trong hệ thống
                  </CardDescription>
                </CardHeader>
                <CardContent>
                  <div className="space-y-6">
                    <div className="space-y-2">
                      <div className="flex items-center justify-between text-sm">
                        <span className="flex items-center">
                          <span className="w-3 h-3 rounded-full bg-red-500 mr-2 shadow-[0_0_10px_rgba(239,68,68,0.5)]"></span>
                          Phát hiện Lửa
                        </span>
                        <span className="font-bold">12%</span>
                      </div>
                      <div className="h-2 w-full bg-secondary rounded-full overflow-hidden">
                        <div className="h-full bg-red-500 w-[12%] animate-pulse"></div>
                      </div>
                    </div>
                    <div className="space-y-2">
                      <div className="flex items-center justify-between text-sm">
                        <span className="flex items-center">
                          <span className="w-3 h-3 rounded-full bg-orange-500 mr-2"></span>
                          Phát hiện Khói
                        </span>
                        <span className="font-bold">28%</span>
                      </div>
                      <div className="h-2 w-full bg-secondary rounded-full overflow-hidden">
                        <div className="h-full bg-orange-500 w-[28%]"></div>
                      </div>
                    </div>
                    <div className="space-y-2">
                      <div className="flex items-center justify-between text-sm">
                        <span className="flex items-center">
                          <span className="w-3 h-3 rounded-full bg-yellow-500 mr-2"></span>
                          Cảnh báo Nhiệt
                        </span>
                        <span className="font-bold">15%</span>
                      </div>
                      <div className="h-2 w-full bg-secondary rounded-full overflow-hidden">
                        <div className="h-full bg-yellow-500 w-[15%]"></div>
                      </div>
                    </div>
                    <div className="space-y-2">
                      <div className="flex items-center justify-between text-sm">
                        <span className="flex items-center">
                          <span className="w-3 h-3 rounded-full bg-blue-500 mr-2"></span>
                          Thông tin Hệ thống
                        </span>
                        <span className="font-bold">45%</span>
                      </div>
                      <div className="h-2 w-full bg-secondary rounded-full overflow-hidden">
                        <div className="h-full bg-blue-500 w-[45%]"></div>
                      </div>
                    </div>
                  </div>

                  <div className="mt-8 p-4 bg-primary/10 rounded-lg border border-primary/20">
                    <h4 className="font-semibold mb-2 text-sm flex items-center gap-2 text-primary">
                      <Shield className="w-4 h-4" /> Đánh giá An toàn
                    </h4>
                    <p className="text-xs text-muted-foreground leading-relaxed">
                      Hệ thống hoạt động ổn định. Tỷ lệ phát hiện đúng đạt mức
                      cao (96%). Các cảnh báo giả đã giảm đáng kể sau khi cập
                      nhật ngưỡng lọc nhiễu (Giai đoạn 3).
                    </p>
                  </div>
                </CardContent>
              </Card>
            </div>
          </TabsContent>

          <TabsContent value="performance">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <Card className="bg-card/50 backdrop-blur border-white/5">
                <CardHeader>
                  <CardTitle>Tốc độ xử lý (FPS)</CardTitle>
                  <CardDescription>
                    Khả năng xử lý thời gian thực trên các luồng camera
                  </CardDescription>
                </CardHeader>
                <CardContent className="h-[300px] flex items-center justify-center">
                  <div className="text-center">
                    <div className="text-6xl font-bold text-primary font-mono mb-2">
                      48
                    </div>
                    <div className="text-sm text-muted-foreground">
                      FPS Trung bình
                    </div>
                    <div className="mt-4 grid grid-cols-3 gap-4 text-xs">
                      <div className="p-2 bg-secondary rounded">Min: 24</div>
                      <div className="p-2 bg-secondary rounded">Max: 60</div>
                      <div className="p-2 bg-secondary rounded">Target: 30</div>
                    </div>
                  </div>
                </CardContent>
              </Card>
              <Card className="bg-card/50 backdrop-blur border-white/5">
                <CardHeader>
                  <CardTitle>Độ trễ (Latency)</CardTitle>
                  <CardDescription>
                    Thời gian từ khi thu hình đến khi phát hiện
                  </CardDescription>
                </CardHeader>
                <CardContent className="h-[300px] flex items-center justify-center">
                  <div className="text-center">
                    <div className="text-6xl font-bold text-green-500 font-mono mb-2">
                      120<span className="text-2xl">ms</span>
                    </div>
                    <div className="text-sm text-muted-foreground">
                      Độ trễ trung bình
                    </div>
                    <div className="mt-4 text-xs p-2 bg-green-500/10 text-green-500 rounded border border-green-500/20">
                      Đạt chuẩn Realtime (&lt;200ms)
                    </div>
                  </div>
                </CardContent>
              </Card>
            </div>
          </TabsContent>

          <TabsContent value="logs">
            <Card className="bg-card/50 backdrop-blur border-white/5">
              <CardHeader>
                <CardTitle>Nhật ký Hoạt động Chi tiết</CardTitle>
                <CardDescription>
                  Ghi lại toàn bộ sự kiện hệ thống và cảnh báo
                </CardDescription>
              </CardHeader>
              <CardContent>
                <div className="rounded-md border border-white/10 overflow-hidden">
                  <table className="w-full text-sm">
                    <thead className="bg-muted/50">
                      <tr className="border-b border-white/10">
                        <th className="p-4 text-left font-medium">Thời gian</th>
                        <th className="p-4 text-left font-medium">Nguồn</th>
                        <th className="p-4 text-left font-medium">Loại</th>
                        <th className="p-4 text-left font-medium">Nội dung</th>
                        <th className="p-4 text-left font-medium">Hành động</th>
                      </tr>
                    </thead>
                    <tbody>
                      {MOCK_LOGS.map((log) => (
                        <tr
                          key={log.id}
                          className="border-b border-white/5 last:border-0 hover:bg-white/5 transition-colors"
                        >
                          <td className="p-4 font-mono text-muted-foreground">
                            {log.timestamp}
                          </td>
                          <td className="p-4 font-medium">{log.camera}</td>
                          <td className="p-4">
                            <span
                              className={cn(
                                "px-2 py-1 rounded text-[10px] font-bold uppercase flex w-fit items-center gap-1",
                                log.type === "CRITICAL" &&
                                  "bg-red-500/20 text-red-500 border border-red-500/20",
                                log.type === "WARNING" &&
                                  "bg-yellow-500/20 text-yellow-500 border border-yellow-500/20",
                                log.type === "ERROR" &&
                                  "bg-orange-500/20 text-orange-500 border border-orange-500/20",
                                log.type === "INFO" &&
                                  "bg-blue-500/20 text-blue-500 border border-blue-500/20"
                              )}
                            >
                              {log.type === "CRITICAL" && (
                                <AlertTriangle className="w-3 h-3" />
                              )}
                              {log.type === "WARNING" && (
                                <AlertCircle className="w-3 h-3" />
                              )}
                              {log.type === "ERROR" && (
                                <WifiOff className="w-3 h-3" />
                              )}
                              {log.type}
                            </span>
                          </td>
                          <td className="p-4 text-muted-foreground">
                            {log.message}
                          </td>
                          <td className="p-4">
                            <Button
                              variant="ghost"
                              size="sm"
                              className="h-8 w-8 p-0 hover:text-primary hover:bg-primary/10"
                            >
                              <FileText className="w-4 h-4" />
                            </Button>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </CardContent>
            </Card>
          </TabsContent>
        </Tabs>
      </main>
    </div>
  );
}
