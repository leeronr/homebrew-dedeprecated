cask "opentamer" do
  version "1.5.0"
  sha256 "38f5c37c46fe43dad58fab80f44b29f869c86f0971d0afaafd42969930027665"

  url "https://github.com/Digital-Shane/OpenTamer/releases/download/v#{version}/OpenTamer-#{version}-macos-arm64.zip"
  name "OpenTamer"
  desc "Open-source utility for managing per-app CPU usage"
  homepage "https://github.com/Digital-Shane/OpenTamer"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "OpenTamer.app"

  zap trash: "~/Library/Application Support/OpenTamer"
end
