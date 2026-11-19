cask "webos-dev-manager" do
  version "1.99.21"
  sha256 "9e0dce29dad332ed6b68e0c25923f90e2a1980b2a1e2fa8251b939a32a71ffff"

  url "https://github.com/webosbrew/dev-manager-desktop/releases/download/v#{version}/webOS.Dev.Manager_#{version}_universal.dmg"
  name "webOS Dev Manager"
  desc "Manage developer mode and rooted webOS TVs"
  homepage "https://github.com/webosbrew/dev-manager-desktop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  auto_updates true
  depends_on :macos

  app "webOS Dev Manager.app"
end
