cask "fiji" do
  arch arm: "-arm64", intel: "64"

  version "20261030-1817"
  sha256 :no_check

  # url "https://downloads.micron.ox.ac.uk/fiji_update/mirrors/fiji-latest/fiji-latest-macos#{arch}-jdk.zip"
  url "https://mirrors.pasteur.fr/fiji/downloads/latest/fiji-latest-macos#{arch}-jdk.zip",
      user_agent: :fake
  # url "https://downloads.imagej.net/fiji/latest/fiji-latest-macos#{arch}-jdk.zip"
  # url "https://downloads.imagej.net/fiji/archive/latest/#{version}/fiji-latest-macos#{arch}-jdk.zip"
  name "Fiji"
  desc "Open-source image processing package"
  homepage "https://fiji.sc/"

  livecheck do
    url "https://downloads.imagej.net/fiji/archive/latest/"
    regex(/(\d{8}-\d{4})/i)
  end

  auto_updates true
  depends_on :macos

  suite "Fiji"

  zap trash: [
    "~/Library/Preferences/sc.fiji.cellcounter.plist",
    "~/Library/Saved Application State/org.fiji.savedState",
  ]
end
