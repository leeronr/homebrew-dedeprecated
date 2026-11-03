cask "okular" do
  arch arm: "arm64", intel: "x86_64"

  sha256 arm:   "3bbc538ee59b5fc11d6685a9dd09c1667d7cfce2851fa73b1796c3b9d89eabb8",
         intel: "49bab39aa8099355e49a31bf6dc4b98b4790af1a14bbbbf67085ae6e4236d23b"

  on_arm do
    version "26.08,8219"
  end
  on_intel do
    version "26.08,8219"
  end

  url "https://cdn.kde.org/ci-builds/graphics/okular/release-#{version.csv.first}/macos-#{arch}/okular-release_#{version.csv.first}-#{version.csv.second}-macos-clang-#{arch}.dmg"
  name "Okular"
  desc "Document viewer and annotator"
  homepage "https://okular.kde.org/"

  livecheck do
    url "https://cdn.kde.org/ci-builds/graphics/okular/"
    regex(/href=.*?okular-release[._-]v?(\d+(?:[.-]\d+)+)[^"' >]*?[._-]#{arch}\.dmg/i)

    strategy :page_match do |page, regex|
      release_dir = page.scan(%r{href=["']?(release[._-]v?(\d+(?:\.\d+)*))/?["' >]}i)
                        .max_by { |match| Version.new(match[1]) }
                        &.first
      next unless release_dir

      builds_page = Homebrew::Livecheck::Strategy.page_content(
        "https://cdn.kde.org/ci-builds/graphics/okular/#{release_dir}/macos-#{arch}/",
      )
      next if (builds_content = builds_page[:content]).blank?

      builds_content.scan(regex).map { |match| match[0].tr("-", ",") }
    end
  end

  depends_on macos: :ventura

  app "okular.app"
  command_wrapper "okular",
                  executable: "#{appdir}/okular.app/Contents/MacOS/okular"

  zap trash: [
    "~/Library/Application Support/okular",
    "~/Library/Preferences/okularpartrc",
    "~/Library/Preferences/okularrc",
    "~/Library/Preferences/org.kde.okular.plist",
  ]
end
