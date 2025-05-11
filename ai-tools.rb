class AiTools < Formula
  desc "Generate AI-friendly project overviews"
  homepage "https://github.com/duanestorey/ai-tools"
  url "https://github.com/duanestorey/ai-tools/archive/refs/tags/1.0.3.tar.gz"
  sha256 "5fccc43977a3b4d7ec22085a2ad2c045df0a9c6ddc1567ae0677f93b1b258a8b"
  license "MIT"
  
  depends_on "php"
  depends_on "composer"
  
  def install
    system "composer", "install", "--no-dev"
    
    # Install the binary
    bin.install "bin/ai-overview"
    
    # Create a wrapper script for easier usage
    (bin/"ai-tools").write <<~EOS
      #!/bin/bash
      PHP_BIN=$(which php)
      SCRIPT_PATH=$(dirname "$0")/ai-overview
      $PHP_BIN "$SCRIPT_PATH" "$@"
    EOS
    chmod 0755, bin/"ai-tools"
  end
  
  test do
    system "#{bin}/ai-tools", "--version"
  end
end
