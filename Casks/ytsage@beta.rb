cask "ytsage@beta" do
  version "5.6.7-beta.1"
  sha256 "4bb4bc36f7e888c73b9ef065d60b98a7d95e9e3abeb5ff724685197b202a0be3"

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

  app "YTSage.app"
end
