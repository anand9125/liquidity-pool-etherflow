import { useState } from "react";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { EthereumInput } from "@/components/ui/ethereum-input";
import { StatusCard } from "@/components/ui/status-card";
import { 
  Wallet, 
  Coins, 
  Plus, 
  Minus, 
  CheckCircle, 
  ExternalLink,
  Droplets,
  Copy
} from "lucide-react";
import { toast } from "@/hooks/use-toast";

type TransactionStatus = "idle" | "loading" | "success" | "error" | "warning";

interface PoolState {
  tokenA: string;
  tokenB: string;
  contractAddress: string;
  amountA: string;
  amountB: string;
}

export function LiquidityPoolManager() {
  const [poolState, setPoolState] = useState<PoolState>({
    tokenA: "",
    tokenB: "",
    contractAddress: "",
    amountA: "",
    amountB: ""
  });

  const [createStatus, setCreateStatus] = useState<TransactionStatus>("idle");
  const [approveStatus, setApproveStatus] = useState<TransactionStatus>("idle");
  const [addStatus, setAddStatus] = useState<TransactionStatus>("idle");
  const [removeStatus, setRemoveStatus] = useState<TransactionStatus>("idle");

  const handleCreatePool = async () => {
    if (!poolState.tokenA || !poolState.tokenB) {
      toast({
        title: "Missing tokens",
        description: "Please enter both token addresses",
        variant: "destructive"
      });
      return;
    }

    setCreateStatus("loading");
    
    // Simulate pool creation
    setTimeout(() => {
      setPoolState(prev => ({ 
        ...prev, 
        contractAddress: `0x${Math.random().toString(16).slice(2, 42)}`
      }));
      setCreateStatus("success");
      toast({
        title: "Pool created successfully!",
        description: "Your liquidity pool has been deployed",
      });
    }, 2000);
  };

  const handleApproveTokens = async () => {
    if (!poolState.contractAddress) {
      toast({
        title: "No pool found",
        description: "Please create a pool first",
        variant: "destructive"
      });
      return;
    }

    setApproveStatus("loading");
    
    setTimeout(() => {
      setApproveStatus("success");
      toast({
        title: "Tokens approved!",
        description: "Both tokens have been approved for the pool",
      });
    }, 1500);
  };

  const handleAddLiquidity = async () => {
    if (!poolState.amountA || !poolState.amountB) {
      toast({
        title: "Missing amounts",
        description: "Please enter amounts for both tokens",
        variant: "destructive"
      });
      return;
    }

    setAddStatus("loading");
    
    setTimeout(() => {
      setAddStatus("success");
      toast({
        title: "Liquidity added!",
        description: `Added ${poolState.amountA} TokenA and ${poolState.amountB} TokenB`,
      });
    }, 2000);
  };

  const handleRemoveLiquidity = async () => {
    setRemoveStatus("loading");
    
    setTimeout(() => {
      setRemoveStatus("success");
      toast({
        title: "Liquidity removed!",
        description: "Your liquidity has been withdrawn from the pool",
      });
    }, 1500);
  };

  const copyToClipboard = (text: string) => {
    navigator.clipboard.writeText(text);
    toast({
      title: "Copied!",
      description: "Address copied to clipboard",
    });
  };

  return (
    <div className="w-full max-w-4xl mx-auto space-y-6">
      <Tabs defaultValue="create" className="w-full">
        <TabsList className="grid w-full grid-cols-4 glass-card">
          <TabsTrigger value="create" className="transition-smooth">
            <Droplets className="h-4 w-4 mr-2" />
            Create Pool
          </TabsTrigger>
          <TabsTrigger value="approve" className="transition-smooth">
            <CheckCircle className="h-4 w-4 mr-2" />
            Approve Tokens
          </TabsTrigger>
          <TabsTrigger value="add" className="transition-smooth">
            <Plus className="h-4 w-4 mr-2" />
            Add Liquidity
          </TabsTrigger>
          <TabsTrigger value="remove" className="transition-smooth">
            <Minus className="h-4 w-4 mr-2" />
            Remove Liquidity
          </TabsTrigger>
        </TabsList>

        <TabsContent value="create" className="space-y-6">
          <Card className="glass-card p-6">
            <div className="space-y-4">
              <div className="flex items-center gap-2 mb-6">
                <Droplets className="h-6 w-6 text-primary" />
                <h2 className="text-2xl font-bold">Create Liquidity Pool</h2>
              </div>

              <div className="grid gap-4 md:grid-cols-2">
                <EthereumInput
                  label="Token A Address"
                  placeholder="0x..."
                  value={poolState.tokenA}
                  onChange={(e) => setPoolState(prev => ({ ...prev, tokenA: e.target.value }))}
                  icon={<Coins className="h-4 w-4" />}
                />
                <EthereumInput
                  label="Token B Address"
                  placeholder="0x..."
                  value={poolState.tokenB}
                  onChange={(e) => setPoolState(prev => ({ ...prev, tokenB: e.target.value }))}
                  icon={<Coins className="h-4 w-4" />}
                />
              </div>

              <Button 
                onClick={handleCreatePool}
                disabled={createStatus === "loading"}
                className="w-full gradient-primary hover:scale-105 transition-spring"
                size="lg"
              >
                {createStatus === "loading" ? "Creating Pool..." : "Create Liquidity Pool"}
              </Button>

              {createStatus !== "idle" && (
                <StatusCard
                  title={createStatus === "loading" ? "Creating Pool" : "Pool Created"}
                  description={
                    createStatus === "loading" 
                      ? "Deploying your liquidity pool contract..."
                      : "Your pool is ready for token approval"
                  }
                  status={createStatus}
                />
              )}

              {poolState.contractAddress && (
                <Card className="glass-card p-4 border-primary/30">
                  <div className="flex items-center justify-between">
                    <div>
                      <h3 className="font-medium text-primary">Pool Contract Address</h3>
                      <p className="text-sm text-muted-foreground font-mono">
                        {poolState.contractAddress}
                      </p>
                    </div>
                    <Button
                      variant="outline"
                      size="sm"
                      onClick={() => copyToClipboard(poolState.contractAddress)}
                      className="ml-2"
                    >
                      <Copy className="h-4 w-4" />
                    </Button>
                  </div>
                </Card>
              )}
            </div>
          </Card>
        </TabsContent>

        <TabsContent value="approve" className="space-y-6">
          <Card className="glass-card p-6">
            <div className="space-y-4">
              <div className="flex items-center gap-2 mb-6">
                <CheckCircle className="h-6 w-6 text-success" />
                <h2 className="text-2xl font-bold">Approve Tokens</h2>
              </div>

              {!poolState.contractAddress ? (
                <StatusCard
                  title="No Pool Found"
                  description="Please create a liquidity pool first before approving tokens."
                  status="warning"
                />
              ) : (
                <>
                  <div className="bg-muted/50 rounded-lg p-4">
                    <p className="text-sm text-muted-foreground">
                      Approve your tokens to allow the pool contract to transfer them on your behalf.
                      This is a one-time approval per token.
                    </p>
                  </div>

                  <Button 
                    onClick={handleApproveTokens}
                    disabled={approveStatus === "loading"}
                    className="w-full gradient-ethereum hover:scale-105 transition-spring"
                    size="lg"
                  >
                    {approveStatus === "loading" ? "Approving..." : "Approve Both Tokens"}
                  </Button>

                  {approveStatus !== "idle" && (
                    <StatusCard
                      title={approveStatus === "loading" ? "Approving Tokens" : "Tokens Approved"}
                      description={
                        approveStatus === "loading" 
                          ? "Confirming token approvals on blockchain..."
                          : "Your tokens are now approved for the liquidity pool"
                      }
                      status={approveStatus}
                    />
                  )}
                </>
              )}
            </div>
          </Card>
        </TabsContent>

        <TabsContent value="add" className="space-y-6">
          <Card className="glass-card p-6">
            <div className="space-y-4">
              <div className="flex items-center gap-2 mb-6">
                <Plus className="h-6 w-6 text-primary" />
                <h2 className="text-2xl font-bold">Add Liquidity</h2>
              </div>

              <div className="grid gap-4 md:grid-cols-2">
                <EthereumInput
                  label="Token A Amount"
                  placeholder="0.0"
                  type="number"
                  value={poolState.amountA}
                  onChange={(e) => setPoolState(prev => ({ ...prev, amountA: e.target.value }))}
                  icon={<Coins className="h-4 w-4" />}
                />
                <EthereumInput
                  label="Token B Amount"
                  placeholder="0.0"
                  type="number"
                  value={poolState.amountB}
                  onChange={(e) => setPoolState(prev => ({ ...prev, amountB: e.target.value }))}
                  icon={<Coins className="h-4 w-4" />}
                />
              </div>

              <Button 
                onClick={handleAddLiquidity}
                disabled={addStatus === "loading" || !poolState.contractAddress}
                className="w-full gradient-primary hover:scale-105 transition-spring"
                size="lg"
              >
                {addStatus === "loading" ? "Adding Liquidity..." : "Add Liquidity"}
              </Button>

              {addStatus !== "idle" && (
                <StatusCard
                  title={addStatus === "loading" ? "Adding Liquidity" : "Liquidity Added"}
                  description={
                    addStatus === "loading" 
                      ? "Processing your liquidity deposit..."
                      : "Your liquidity has been successfully added to the pool"
                  }
                  status={addStatus}
                />
              )}
            </div>
          </Card>
        </TabsContent>

        <TabsContent value="remove" className="space-y-6">
          <Card className="glass-card p-6">
            <div className="space-y-4">
              <div className="flex items-center gap-2 mb-6">
                <Minus className="h-6 w-6 text-warning" />
                <h2 className="text-2xl font-bold">Remove Liquidity</h2>
              </div>

              <div className="bg-warning/10 border border-warning/20 rounded-lg p-4">
                <p className="text-sm text-warning-foreground">
                  <strong>Warning:</strong> Removing liquidity will withdraw your tokens from the pool.
                  This action cannot be undone.
                </p>
              </div>

              <EthereumInput
                label="LP Token Amount"
                placeholder="0.0"
                type="number"
                helperText="Amount of LP tokens to burn"
                icon={<Droplets className="h-4 w-4" />}
              />

              <Button 
                onClick={handleRemoveLiquidity}
                disabled={removeStatus === "loading" || !poolState.contractAddress}
                variant="destructive"
                className="w-full hover:scale-105 transition-spring"
                size="lg"
              >
                {removeStatus === "loading" ? "Removing Liquidity..." : "Remove Liquidity"}
              </Button>

              {removeStatus !== "idle" && (
                <StatusCard
                  title={removeStatus === "loading" ? "Removing Liquidity" : "Liquidity Removed"}
                  description={
                    removeStatus === "loading" 
                      ? "Processing your liquidity withdrawal..."
                      : "Your liquidity has been successfully removed from the pool"
                  }
                  status={removeStatus}
                />
              )}
            </div>
          </Card>
        </TabsContent>
      </Tabs>
    </div>
  );
}