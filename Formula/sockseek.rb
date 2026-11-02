class Sockseek < Formula
  desc "Command-line Soulseek client and downloader"
  homepage "https://github.com/fiso64/sockseek"
  version "3.0.6"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  if Hardware::CPU.arm?
    url "https://github.com/fiso64/sockseek/releases/download/v#{version}/sockseek_#{version}_osx-arm64.tar.gz"
    sha256 "b7b9602b3ea0d8724b2a4dd1370c97f2f1f7175f901e7088dad714352c4926d9"
  else
    url "https://github.com/fiso64/sockseek/releases/download/v#{version}/sockseek_#{version}_osx-x64.tar.gz"
    sha256 "6211374e1fca1f0b0bb4bfc6395e493c5969416e116a976f87bac4bdb99320fd"
  end

  def install
    bin.install "sockseek"
  end

  test do
    assert_match "sockseek", shell_output("#{bin}/sockseek --help")
  end
end
