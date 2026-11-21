cask "blunderdb" do
  version "0.58.0"
  sha256 "d7145e3c9a4195ed0f6401c2c7e04c9e7119473d1387b4fe9d26a134d5d9bea7"

  url "https://github.com/kevung/blunderDB/releases/download/#{version}/blunderDB-macos-#{version}.zip"
  name "blunderDB"
  desc "Backgammon blunder analysis tool"
  homepage "https://github.com/kevung/blunderDB"

  livecheck do
    url :url
    strategy :github_latest
  end

  # The release zip holds one universal (arm64 + x86_64) bundle whose name and
  # executable are both versioned: blunderDB-macos-<v>.app/Contents/MacOS/
  # blunderDB-macos-<v>. It is installed under a stable name so the Finder
  # entry does not change on upgrade; the executable is also linked as
  # `blunderdb` because the same binary is the command-line interface.
  depends_on :macos

  app "blunderDB-macos-#{version}.app", target: "blunderDB.app"
  binary "#{appdir}/blunderDB.app/Contents/MacOS/blunderDB-macos-#{version}", target: "blunderdb"
  # `blunderdb completion <shell>` prints the script (B.8, #176); Homebrew
  # runs it once at install time and stows the output where each shell looks
  # for completions on its own — nothing to source manually.
  generate_completions_from_executable(
    "#{appdir}/blunderDB.app/Contents/MacOS/blunderDB-macos-#{version}",
    "completion",
    shells: [:bash, :zsh, :fish],
    # shell_parameter_format: :arg,
  )

  zap trash: [
    "~/Library/Application Support/blunderDB",
    "~/Library/Caches/blunderDB",
  ]

  caveats <<~EOS
    blunderDB is not signed with an Apple Developer certificate and is not
    notarized, so Gatekeeper refuses to open it the first time. Either
    right-click blunderDB.app in /Applications and choose Open (once), or
    install with the quarantine attribute left off:

      brew install --cask --no-quarantine blunderdb

    Details: https://kevung.github.io/blunderDB/en/annexe_mac_securite.html
  EOS
end
