import * as React from "react";
import { cn } from "@/lib/utils";
import { CheckCircle, XCircle, AlertCircle, Loader2 } from "lucide-react";

interface StatusCardProps {
  title: string;
  description?: string;
  status: "idle" | "loading" | "success" | "error" | "warning";
  className?: string;
  children?: React.ReactNode;
}

const statusConfig = {
  idle: {
    icon: AlertCircle,
    className: "border-muted",
    iconClassName: "text-muted-foreground"
  },
  loading: {
    icon: Loader2,
    className: "border-primary/50 glow-primary",
    iconClassName: "text-primary animate-spin"
  },
  success: {
    icon: CheckCircle,
    className: "border-success/50 bg-success/5",
    iconClassName: "text-success"
  },
  error: {
    icon: XCircle,
    className: "border-destructive/50 bg-destructive/5",
    iconClassName: "text-destructive"
  },
  warning: {
    icon: AlertCircle,
    className: "border-warning/50 bg-warning/5",
    iconClassName: "text-warning"
  }
};

export function StatusCard({ title, description, status, className, children }: StatusCardProps) {
  const config = statusConfig[status];
  const Icon = config.icon;

  return (
    <div
      className={cn(
        "glass-card p-4 transition-smooth animate-slide-up",
        config.className,
        className
      )}
    >
      <div className="flex items-start gap-3">
        <Icon className={cn("h-5 w-5 mt-0.5", config.iconClassName)} />
        <div className="flex-1 space-y-1">
          <h3 className="font-medium text-foreground">{title}</h3>
          {description && (
            <p className="text-sm text-muted-foreground">{description}</p>
          )}
          {children}
        </div>
      </div>
    </div>
  );
}