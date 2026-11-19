cask "okular" do
  arch arm: "arm64", intel: "x86_64"

  sha256 arm:   "dd2dfb84457909fb663a066a0431242b155402d7e2817a209389173b9324d117",
         intel: "4f9011e6665b2eaf472d96b7d270227a8b732110caad6e8b0741880ca820308a"

  on_arm do
    version "26.12,8321"
  end
  on_intel do
    version "26.12,8321"
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
