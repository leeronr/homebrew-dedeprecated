cask "ytsage@beta" do
  version "5.6.9-beta.1"
  sha256 "47ea1025115842f4107679ffe82c4b1677a422fa96ea1129a3c090b0db1cb990"

  url "https://github.com/oop7/YTSage/releases/download/v#{version}/YTSage-v#{version}-arm64.dmg"
  name "YTSage Beta"
  desc "Development and prerelease builds of YTSage"
  homepage "https://github.com/oop7/YTSage"

  livecheck do
    url "https://github.com/oop7/YTSage"
    regex(/^v?(\d+(?:\.\d+)+(?:-[0-9A-Za-z.-]+)?)$/i)

    strategy :github_releases do |json, regex|
      json.filter_map do |release|
        next if release["draft"]

        release["tag_name"]&.[](regex, 1)
      end
    end
  end

  conflicts_with cask: "ytsage"
  depends_on arch: :arm64
  depends_on :macos

  app "YTSage-v#{version}.app", target: "YTSage.app"
end
