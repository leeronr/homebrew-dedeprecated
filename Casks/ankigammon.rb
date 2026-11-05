cask "ankigammon" do
  version "1.20.0"
  sha256 "c7155198825e499f51d4fa1c7cea06b054a2a13c9d807c642f7e8aeabfab8c3c"

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
