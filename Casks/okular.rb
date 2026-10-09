cask "okular" do
  arch arm: "arm64", intel: "x86_64"

  version "26.08,8135"
  sha256 arm:   "b79c29c2d1fc2a7ed05fe5cd270600c2eff109b3eb367823c2386bd89e6dfe59",
         intel: "2c13309aa181e593f56bf6a836530204928b330ff10e4f449a0185dbda2e710b"

  url "https://cdn.kde.org/ci-builds/graphics/okular/release-#{version.csv.first}/macos-#{arch}/okular-release_#{version.csv.first}-#{version.csv.second}-macos-clang-#{arch}.dmg"
  name "Okular"
  desc "Universal document viewer"
  homepage "https://okular.kde.org/"

  livecheck do
    url "https://cdn.kde.org/ci-builds/graphics/okular/"

    regex(%r{href=["']?release-(\d+\.\d+)/?["' >]}i)

    strategy :page_match do |page, regex|
      releases = page.scan(regex).flatten.uniq.sort_by do |release|
        Gem::Version.new(release)
      end.reverse

      releases.filter_map do |release|
        build_url = "https://cdn.kde.org/ci-builds/graphics/okular/release-#{release}/macos-#{arch}/"

        response = Homebrew::Livecheck::Strategy.page_content(build_url)
        next if response.blank?

        content = response[:content]
        next if content.blank?

        build_regex = /
          href=["']?okular-release_#{Regexp.escape(release)}-(\d+)
          -macos-clang-#{Regexp.escape(arch)}\.dmg["' >]
        /ix

        builds = content.scan(build_regex).flatten.map(&:to_i)
        next if builds.empty?

        "#{release},#{builds.max}"
      end
    end
  end

  depends_on :macos

  app "okular.app"
end
