cask "sockseek" do
  arch arm: "arm64", intel: "x64"

  version "3.1.0"
  sha256 arm:   "22457f9dc07d7e1ad95a7d201a29d2fcdee83ee6298e86308ef2dc6648374f7d",
         intel: "26cc4d5c4281b17dd018765cedcb433ac8ff62ebe1a980207dcfe8ae85d14804"

  url "https://github.com/fiso64/sockseek/releases/download/v#{version}/sockseek_#{version}_osx-#{arch}.tar.gz"
  name "Sockseek"
  desc "Command-line Soulseek client and downloader"
  homepage "https://github.com/fiso64/sockseek"

  livecheck do
    url :url
    strategy :github_latest
  end

  binary "sockseek"
end
