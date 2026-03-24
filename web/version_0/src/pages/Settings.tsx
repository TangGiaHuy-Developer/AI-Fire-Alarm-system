import { useState } from "react";
import {
  Save,
  Bell,
  Shield,
  Server,
  Users,
  Eye,
  Wifi,
  Database,
} from "lucide-react";
// import { cn } from "@/lib/utils";
import { Switch } from "@/components/ui/switch";
import { Label } from "@/components/ui/label";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Separator } from "@/components/ui/separator";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { useToast } from "@/hooks/use-toast";

export default function Settings() {
  const { toast } = useToast();
  const [loading, setLoading] = useState(false);

  const handleSave = () => {
    setLoading(true);
    // Simulate API call
    setTimeout(() => {
      setLoading(false);
      toast({
        title: "Đã lưu Cài đặt",
        description: "Cấu hình hệ thống đã được cập nhật thành công.",
      });
    }, 1000);
  };

  return (
    <div className="flex flex-col h-screen bg-background text-foreground font-sans overflow-hidden">
      <header className="h-16 border-b border-border flex items-center justify-between px-8 bg-card/50 backdrop-blur shrink-0">
        <div>
          <h1 className="text-2xl font-bold tracking-tight">
            Cài đặt Hệ thống
          </h1>
          <p className="text-sm text-muted-foreground">
            Quản lý cấu hình DeepBlue FireGuard
          </p>
        </div>
        <Button
          onClick={handleSave}
          disabled={loading}
          className="bg-primary hover:bg-primary/90 text-primary-foreground"
        >
          {loading ? "Đang lưu..." : "Lưu Thay đổi"}
        </Button>
      </header>

      <div className="flex-1 overflow-y-auto p-8">
        <div className="max-w-4xl mx-auto">
          <Tabs defaultValue="general" className="space-y-6">
            <TabsList className="grid w-full grid-cols-4 bg-secondary p-1 rounded-lg">
              <TabsTrigger
                value="general"
                className="data-[state=active]:bg-card data-[state=active]:text-primary font-medium"
              >
                Chung
              </TabsTrigger>
              <TabsTrigger
                value="camera"
                className="data-[state=active]:bg-card data-[state=active]:text-primary font-medium"
              >
                AI & Camera
              </TabsTrigger>
              <TabsTrigger
                value="notifications"
                className="data-[state=active]:bg-card data-[state=active]:text-primary font-medium"
              >
                Thông báo
              </TabsTrigger>
              <TabsTrigger
                value="network"
                className="data-[state=active]:bg-card data-[state=active]:text-primary font-medium"
              >
                Mạng
              </TabsTrigger>
            </TabsList>

            {/* GENERAL TAB */}
            <TabsContent value="general" className="space-y-6">
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Shield className="w-5 h-5 text-primary" /> Định danh Hệ
                    thống
                  </CardTitle>
                  <CardDescription>
                    Cấu hình thông tin hệ thống cơ bản và vị trí.
                  </CardDescription>
                </CardHeader>
                <CardContent className="space-y-4">
                  <div className="grid grid-cols-2 gap-4">
                    <div className="space-y-2">
                      <Label htmlFor="sys-name">Tên Hệ thống</Label>
                      <Input
                        id="sys-name"
                        defaultValue="DeepBlue FireGuard HQ"
                      />
                    </div>
                    <div className="space-y-2">
                      <Label htmlFor="location">Vị trí</Label>
                      <Input
                        id="location"
                        defaultValue="Tòa nhà A, Khu Công nghệ"
                      />
                    </div>
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="admin-email">Email Liên hệ Quản trị</Label>
                    <Input
                      id="admin-email"
                      type="email"
                      defaultValue="admin@deepblue.ai"
                    />
                  </div>
                </CardContent>
              </Card>

              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Users className="w-5 h-5 text-primary" /> Kiểm soát Truy
                    cập
                  </CardTitle>
                  <CardDescription>
                    Quản lý vai trò người dùng và cấp độ bảo mật.
                  </CardDescription>
                </CardHeader>
                <CardContent className="space-y-4">
                  <div className="flex items-center justify-between">
                    <div className="space-y-0.5">
                      <Label className="text-base">
                        Xác thực Hai yếu tố (2FA)
                      </Label>
                      <p className="text-sm text-muted-foreground">
                        Yêu cầu 2FA cho mọi thao tác quản trị
                      </p>
                    </div>
                    <Switch defaultChecked />
                  </div>
                  <Separator />
                  <div className="flex items-center justify-between">
                    <div className="space-y-0.5">
                      <Label className="text-base">Truy cập Khách</Label>
                      <p className="text-sm text-muted-foreground">
                        Cho phép truy cập chỉ xem cho tài khoản khách
                      </p>
                    </div>
                    <Switch />
                  </div>
                </CardContent>
              </Card>
            </TabsContent>

            {/* AI & CAMERA TAB */}
            <TabsContent value="camera" className="space-y-6">
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Eye className="w-5 h-5 text-primary" /> Độ nhạy Phát hiện
                  </CardTitle>
                  <CardDescription>
                    Tinh chỉnh ngưỡng mô hình AI cho Khói và Lửa.
                  </CardDescription>
                </CardHeader>
                <CardContent className="space-y-6">
                  <div className="space-y-4">
                    <div className="flex justify-between items-center">
                      <Label>Ngưỡng tin cậy Lửa</Label>
                      <span className="font-mono text-primary font-bold">
                        85%
                      </span>
                    </div>
                    <input
                      type="range"
                      min="50"
                      max="99"
                      defaultValue="85"
                      className="w-full h-2 bg-secondary rounded-lg appearance-none cursor-pointer accent-primary"
                    />
                    <p className="text-xs text-muted-foreground">
                      Giá trị thấp hơn tăng phạm vi phát hiện nhưng có thể gây
                      báo động giả.
                    </p>
                  </div>

                  <div className="space-y-4">
                    <div className="flex justify-between items-center">
                      <Label>Độ nhạy Mật độ Khói</Label>
                      <span className="font-mono text-primary font-bold">
                        Trung bình
                      </span>
                    </div>
                    <div className="flex justify-between text-xs text-muted-foreground px-1">
                      <span>Thấp</span>
                      <span>Trung bình</span>
                      <span>Cao</span>
                    </div>
                    <input
                      type="range"
                      min="1"
                      max="3"
                      step="1"
                      defaultValue="2"
                      className="w-full h-2 bg-secondary rounded-lg appearance-none cursor-pointer accent-primary"
                    />
                  </div>
                </CardContent>
              </Card>

              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Database className="w-5 h-5 text-primary" /> Lưu trữ Bản
                    ghi
                  </CardTitle>
                </CardHeader>
                <CardContent className="space-y-4">
                  <div className="grid grid-cols-2 gap-4">
                    <div className="space-y-2">
                      <Label>Cảnh quay Bình thường</Label>
                      <select className="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2">
                        <option>7 Ngày</option>
                        <option>30 Ngày</option>
                        <option>90 Ngày</option>
                      </select>
                    </div>
                    <div className="space-y-2">
                      <Label>Cảnh quay Sự kiện/Cảnh báo</Label>
                      <select className="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2">
                        <option>1 Năm</option>
                        <option>3 Năm</option>
                        <option>Vĩnh viễn</option>
                      </select>
                    </div>
                  </div>
                </CardContent>
              </Card>
            </TabsContent>

            {/* NOTIFICATIONS TAB */}
            <TabsContent value="notifications" className="space-y-6">
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Bell className="w-5 h-5 text-primary" /> Kênh Cảnh báo
                  </CardTitle>
                  <CardDescription>
                    Cấu hình nơi gửi cảnh báo quan trọng.
                  </CardDescription>
                </CardHeader>
                <CardContent className="space-y-4">
                  <div className="flex items-center justify-between p-4 border border-border rounded-lg">
                    <div className="flex items-center gap-4">
                      <div className="p-2 bg-blue-500/20 rounded-full text-blue-500">
                        <Bell className="w-5 h-5" />
                      </div>
                      <div>
                        <p className="font-medium">Thông báo Đẩy</p>
                        <p className="text-sm text-muted-foreground">
                          Gửi đến ứng dụng di động
                        </p>
                      </div>
                    </div>
                    <Switch defaultChecked />
                  </div>

                  <div className="flex items-center justify-between p-4 border border-border rounded-lg">
                    <div className="flex items-center gap-4">
                      <div className="p-2 bg-green-500/20 rounded-full text-green-500">
                        <div className="w-5 h-5 font-bold text-center leading-5">
                          @
                        </div>
                      </div>
                      <div>
                        <p className="font-medium">Cảnh báo Email</p>
                        <p className="text-sm text-muted-foreground">
                          Gửi đến admin@deepblue.ai
                        </p>
                      </div>
                    </div>
                    <Switch defaultChecked />
                  </div>

                  <div className="flex items-center justify-between p-4 border border-border rounded-lg">
                    <div className="flex items-center gap-4">
                      <div className="p-2 bg-indigo-500/20 rounded-full text-indigo-500">
                        <div className="w-5 h-5 font-bold text-center leading-5">
                          T
                        </div>
                      </div>
                      <div>
                        <p className="font-medium">Bot Telegram</p>
                        <p className="text-sm text-muted-foreground">
                          Gửi đến kênh đã cấu hình
                        </p>
                      </div>
                    </div>
                    <Switch />
                  </div>
                </CardContent>
              </Card>
            </TabsContent>

            {/* NETWORK TAB */}
            <TabsContent value="network" className="space-y-6">
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Server className="w-5 h-5 text-primary" /> Cấu hình Máy chủ
                  </CardTitle>
                </CardHeader>
                <CardContent className="space-y-4">
                  <div className="grid grid-cols-2 gap-4">
                    <div className="space-y-2">
                      <Label>Địa chỉ IP</Label>
                      <Input
                        defaultValue="192.168.1.100"
                        className="font-mono"
                      />
                    </div>
                    <div className="space-y-2">
                      <Label>Cổng</Label>
                      <Input defaultValue="8080" className="font-mono" />
                    </div>
                  </div>
                  <div className="flex items-center justify-between pt-4">
                    <div className="space-y-0.5">
                      <Label className="text-base">Đồng bộ Đám mây</Label>
                      <p className="text-sm text-muted-foreground">
                        Sao lưu dữ liệu sang AWS S3
                      </p>
                    </div>
                    <Switch />
                  </div>
                </CardContent>
              </Card>
            </TabsContent>
          </Tabs>
        </div>
      </div>
    </div>
  );
}
