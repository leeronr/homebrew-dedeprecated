cask "chromedriver" do
  arch arm: "arm64", intel: "x64"

  version "156.0.8078.73"
  sha256 arm:   "abb23cd13ac8d39201dd7f78a81941c4dbb6af008dc1245dc30ec04e879b3f41",
         intel: "447f5d7f4bc33b84db6b6e1da7c637802acfd91bee6bce9cbaf797e31dc67956"

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
