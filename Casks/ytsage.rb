cask "ytsage" do
  version "5.6.5"
  sha256 "8daf10a00d6893ee027082a401a4802d67507bb8542c3a21bccd1935470a1ae3"

  url "https://github.com/oop7/YTSage/releases/download/v#{version}/YTSage-v#{version}-arm64.dmg"
  name "YTSage"
  desc "GUI application for downloading videos from YouTube and other platforms"
  homepage "https://github.com/oop7/YTSage"

  livecheck do
    url :url
    strategy :github_latest
  end

  conflicts_with cask: "ytsage@beta"
  depends_on arch: :arm
  depends_on :macos

  app "YTSage.app"
end
