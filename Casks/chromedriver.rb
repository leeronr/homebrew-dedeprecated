cask "chromedriver" do
  arch arm: "arm64", intel: "x64"

  version "155.0.8059.79"
  sha256 arm:   "ca9a98c74b8d3904be6536ff6d26493abb7d7a476e2b384a75cd55d101bce29d",
         intel: "5e908dcc08f8d714cd9cef9ce036710e61d833f7094743647189b53903fda44f"

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
