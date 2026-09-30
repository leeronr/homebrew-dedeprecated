cask "chromedriver" do
  arch arm: "arm64", intel: "x64"

  version "154.0.8037.92"
  sha256 arm:   "7642a748afb35ecf58183f3d0f41309cf2a239833a612518bcdc2f50347660ac",
         intel: "cb03fe8181c391d5604e86b0c6df32e05ddc759484526fe4aeb7686526307e34"

  url "https://storage.googleapis.com/chrome-for-testing-public/#{version}/mac-#{arch}/chromedriver-mac-#{arch}.zip"
  name "ChromeDriver"
  desc "Automated testing of webapps for Google Chrome"
  homepage "https://chromedriver.chromium.org/"

  livecheck do
    url "https://googlechromelabs.github.io/chrome-for-testing/last-known-good-versions.json"
    strategy :json do |json|
      json.dig("channels", "Stable", "version")
    end
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  conflicts_with cask: "chromedriver@beta"
  depends_on :macos

  binary "chromedriver-mac-#{arch}/chromedriver"

  # No zap stanza required
end
