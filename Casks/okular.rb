cask "okular" do
  arch arm: "arm64", intel: "x86_64"

  sha256 arm:   "1f35e0473c366dfa8932d88416aff3beaa684e1561db9b598f7d1de856288cc0",
         intel: "5c9dd6cf103c41f47453973cffee21adde90ef3b8a39fae8e25dc17ba7a95608"

  on_arm do
    version "26.12,8286"
  end
  on_intel do
    version "26.12,8286"
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
