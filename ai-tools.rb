name: Update Homebrew Formula

# This workflow updates the Homebrew formula in the homebrew-ai-tools repository
# when you publish a new release in your main ai-tools repository

on:
  release:
    types: [published]

jobs:
  update-formula:
    runs-on: ubuntu-latest
    steps:
      # First checkout your main repository (ai-tools)
      - name: Checkout main repo
        uses: actions/checkout@v2
        
      # Get information about the release
      - name: Get release info
        id: release
        run: |
          echo "::set-output name=version::${GITHUB_REF#refs/tags/}"
          echo "::set-output name=tarball_url::https://github.com/duanestorey/ai-tools/archive/refs/tags/${GITHUB_REF#refs/tags/}.tar.gz"
          
      # Calculate the SHA256 hash of the release tarball
      - name: Download tarball and calculate SHA256
        id: sha
        run: |
          curl -sL "${{ steps.release.outputs.tarball_url }}" -o release.tar.gz
          echo "::set-output name=sha256::$(sha256sum release.tar.gz | awk '{print $1}')"
          
      # Checkout the separate Homebrew tap repository (homebrew-ai-tools)
      # This is a separate repository required by Homebrew's naming convention
      - name: Checkout homebrew tap repo
        uses: actions/checkout@v2
        with:
          repository: duanestorey/homebrew-ai-tools
          token: ${{ secrets.TAP_REPO_TOKEN }}
          path: homebrew-ai-tools
          
      # Update the formula with the new version information
      - name: Update formula
        run: |
          sed -i 's|url "https://github.com/duanestorey/ai-tools/archive/refs/tags/1.0.5.tar.gz"|' homebrew-ai-tools/ai-tools.rb
          sed -i 's|sha256 "9dacd91aca044bc160df08e7d5a3adf8588254d5f5491301bfc806988be19600"|' homebrew-ai-tools/ai-tools.rb
          
      # Commit and push the changes to the Homebrew tap repository
      - name: Commit and push changes
        run: |
          cd homebrew-ai-tools
          git config user.name "GitHub Action"
          git config user.email "action@github.com"
          git add ai-tools.rb
          git commit -m "Update to version ${{ steps.release.outputs.version }}"
          git push
