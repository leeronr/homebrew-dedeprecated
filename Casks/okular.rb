cask "okular" do
  arch arm: "arm64", intel: "x86_64"

  sha256 arm:   "6f6c597eef6cf22076a40ed728ef8050ae2342c606a7f5eacf0d7e8aec00e589",
         intel: "b6b724d39cfa4c5f453b88675623ed7bb7f3cb684ae95859105a1f749beb30f8"

  on_arm do
    version "26.08,8165"
  end
  on_intel do
    version "26.08,8165"
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
