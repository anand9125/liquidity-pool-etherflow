import * as React from "react";
import { cn } from "@/lib/utils";
import { Input } from "@/components/ui/input";

export interface EthereumInputProps
  extends React.InputHTMLAttributes<HTMLInputElement> {
  label?: string;
  helperText?: string;
  error?: string;
  icon?: React.ReactNode;
}

const EthereumInput = React.forwardRef<HTMLInputElement, EthereumInputProps>(
  ({ className, label, helperText, error, icon, ...props }, ref) => {
    return (
      <div className="space-y-2">
        {label && (
          <label className="text-sm font-medium text-foreground/90">
            {label}
          </label>
        )}
        <div className="relative">
          {icon && (
            <div className="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground">
              {icon}
            </div>
          )}
          <Input
            className={cn(
              "glass-card transition-smooth",
              "focus:glow-primary focus:border-primary/50",
              "hover:border-primary/30",
              icon && "pl-10",
              error && "border-destructive/50 focus:border-destructive",
              className
            )}
            ref={ref}
            {...props}
          />
        </div>
        {(helperText || error) && (
          <p
            className={cn(
              "text-xs",
              error ? "text-destructive" : "text-muted-foreground"
            )}
          >
            {error || helperText}
          </p>
        )}
      </div>
    );
  }
);
EthereumInput.displayName = "EthereumInput";

export { EthereumInput };