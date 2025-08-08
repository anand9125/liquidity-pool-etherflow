import { LiquidityPoolManager } from "@/components/LiquidityPoolManager";
import { Wallet, Droplets, Shield, Zap } from "lucide-react";
import heroImage from "@/assets/hero-bg.jpg";

const Index = () => {
  return (
    <div className="min-h-screen bg-background">
      {/* Hero Section */}
      <div className="relative overflow-hidden">
        <div 
          className="absolute inset-0 opacity-20"
          style={{
            backgroundImage: `url(${heroImage})`,
            backgroundSize: 'cover',
            backgroundPosition: 'center',
          }}
        />
        <div className="relative container mx-auto px-4 py-16 text-center">
          <div className="animate-slide-up">
            <h1 className="text-6xl md:text-8xl font-bold mb-6 gradient-primary bg-clip-text text-transparent">
              EtherFlow
            </h1>
            <p className="text-xl md:text-2xl text-muted-foreground mb-8 max-w-3xl mx-auto">
              Create and manage Ethereum liquidity pools with an intuitive, powerful interface.
              Experience DeFi like never before.
            </p>
            
            <div className="flex flex-wrap justify-center gap-6 mb-12">
              <div className="flex items-center gap-2 glass-card px-4 py-2">
                <Shield className="h-5 w-5 text-success" />
                <span className="text-sm">Secure</span>
              </div>
              <div className="flex items-center gap-2 glass-card px-4 py-2">
                <Zap className="h-5 w-5 text-warning" />
                <span className="text-sm">Fast</span>
              </div>
              <div className="flex items-center gap-2 glass-card px-4 py-2">
                <Droplets className="h-5 w-5 text-primary" />
                <span className="text-sm">Efficient</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Main Content */}
      <div className="container mx-auto px-4 py-12">
        <div className="mb-12 text-center">
          <h2 className="text-3xl font-bold mb-4">Liquidity Pool Management</h2>
          <p className="text-muted-foreground max-w-2xl mx-auto">
            Create, manage, and optimize your Ethereum liquidity pools with our comprehensive suite of tools.
            From pool creation to liquidity management, we've got you covered.
          </p>
        </div>

        <LiquidityPoolManager />
      </div>

      {/* Footer */}
      <footer className="border-t border-border/50 mt-20">
        <div className="container mx-auto px-4 py-8">
          <div className="flex flex-col md:flex-row justify-between items-center gap-4">
            <div className="flex items-center gap-2">
              <Droplets className="h-6 w-6 text-primary" />
              <span className="font-bold text-xl">EtherFlow</span>
            </div>
            <p className="text-sm text-muted-foreground">
              Built for the future of decentralized finance
            </p>
          </div>
        </div>
      </footer>
    </div>
  );
};

export default Index;
