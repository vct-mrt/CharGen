class Chargen < Formula
  desc "Command-line random character generator"
  homepage "https://github.com/vct-mrt/CharGen"
  url "https://github.com/vct-mrt/CharGen/archive/refs/tags/v1.0.0.tar.gz"
  # PLACEHOLDER: replace with the real tarball digest before publishing.
  # Compute it with either of:
  #   brew fetch --build-from-source ./Formula/chargen.rb
  #   curl -sL https://github.com/vct-mrt/CharGen/archive/refs/tags/v1.0.0.tar.gz | shasum -a 256
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  license "GPL-3.0-or-later"

  head "https://github.com/vct-mrt/CharGen.git", branch: "main"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/chargen 16")
    assert_equal 16, output.chomp.length

    version_output = shell_output("#{bin}/chargen --version")
    assert_match "CharGen version #{version}", version_output
    assert_match "License GPLv3+", version_output

    help_output = shell_output("#{bin}/chargen --help")
    assert_match "Usage: chargen [options] <number>", help_output
  end
end
