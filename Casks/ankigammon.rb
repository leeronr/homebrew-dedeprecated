cask "ankigammon" do
  version "1.18.1"
  sha256 "99172279d693bcf83232e13fc13b6d3e3ac4fbab7eecf24ae2ae6eca426c4b2b"

  url "https://github.com/Deinonychus999/AnkiGammon/releases/download/v#{version}/AnkiGammon-macOS.dmg"
  name "AnkiGammon"
  desc "Turn backgammon mistakes into Anki flashcards"
  homepage "https://ankigammon.com/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app "AnkiGammon.app"

  zap trash: [
    "~/Library/Caches/AnkiGammon",
    "~/Library/Preferences/com.ankigammon.app.plist",
  ]
end
