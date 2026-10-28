cask "escrcpy" do
  version "3.3.1"

  on_arm do
    arch "arm64"

    sha256 "9f46fb7199c2666cc7ab73851a2dc5b7aa15942782f89d118eaffb906208eb0c"
  end
  on_intel do
    arch "x64"

    sha256 "e14dcd10247f94671083dc74f520cff4e92d045244c41b609f9346fd04b1fec5"
  end

  url "https://github.com/viarotel-org/escrcpy/releases/download/v#{version}/Escrcpy-#{version}-mac-#{arch}.dmg",
      verified: "github.com/viarotel-org/escrcpy/"
  name "Escrcpy"
  desc "Graphical interface for scrcpy to mirror and control Android devices"
  homepage "https://github.com/viarotel-org/escrcpy"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app "Escrcpy.app"

  zap trash: [
    "~/Library/Application Support/escrcpy",
    "~/Library/Preferences/org.viarotel.escrcpy.plist",
  ]
end
