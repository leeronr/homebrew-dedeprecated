cask "ankigammon" do
  version "1.19.1"
  sha256 "0b4ee5658d00dcfa44a98cd58f837d9f08fe0271e04b2248bc27053eda2ed347"

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
