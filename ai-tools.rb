class AiTools < Formula
  desc "Generate AI-friendly project overviews"
  homepage "https://github.com/duanestorey/ai-tools"
  url "https://github.com/duanestorey/ai-tools/archive/refs/tags/1.1.0.tar.gz"
  sha256 "204040ad5ac670bc31e9e45d8ec28098161a32a7b152167792db7220f3451e56"
  license "MIT"
  
  depends_on "php"
  depends_on "composer"
  
  def install
    # Install composer dependencies
    system "composer", "install", "--no-dev", "--prefer-dist"
    
    # Create the libexec directory to store the package files
    libexec.install Dir["*"]
    
    # Create a wrapper script for the ai-overview command
    (bin/"ai-overview").write <<~EOS
      #!/bin/bash
      PHP_BIN=$(which php)
      SCRIPT_PATH=#{libexec}/bin/ai-overview
      $PHP_BIN "$SCRIPT_PATH" "$@"
    EOS
    chmod 0755, bin/"ai-overview"
    
    # Create a wrapper script for easier usage with ai-tools name
    (bin/"ai-tools").write <<~EOS
      #!/bin/bash
      PHP_BIN=$(which php)
      SCRIPT_PATH=#{libexec}/bin/ai-overview
      $PHP_BIN "$SCRIPT_PATH" "$@"
    EOS
    chmod 0755, bin/"ai-tools"
  end
  
  test do
    system "#{bin}/ai-tools", "--version"
  end
end
