cask "opentamer" do
  version "1.4.1"
  sha256 "ef64b259e4c881ffddb4922f1311bb22ad394374151469e1f9aaaf0658a1b59c"

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
