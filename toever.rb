require "formula"

class Toever < Formula
  homepage "https://github.com/ngc224/toever/"
  url "https://pypi.python.org/packages/source/t/toever/toever-1.9.2.tar.gz"
  sha1 "f7fdc8510a4085885cd7d101abf1bc964e6de0c6"

  resource "evernote" do
    url "https://pypi.python.org/packages/source/e/evernote/evernote-1.25.0.tar.gz"
    sha1 "48b8077cce90a4001b0cf969e86d13e2c3de7916"
  end

  resource "clint" do
    url "https://pypi.python.org/packages/source/c/clint/clint-0.4.1.tar.gz"
    sha1 "38f026413d4240e5fc97f140529462603cd3686b"
  end

  resource "chardet" do
    url "https://pypi.python.org/packages/source/c/chardet/chardet-2.3.0.tar.gz"
    sha1 "50af8f8771ecbeb7a22567129c6c281b8bec3b1c"
  end

  resource "keyring" do
    url "https://pypi.python.org/packages/source/k/keyring/keyring-4.0.zip"
    sha1 "45d6d052dda9ba5ed072e29abf88b1b473cb38c4"
  end

  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", prefix+"lib/python2.7/site-packages"
    install_args = [ "setup.py", "install", "--prefix=#{libexec}" ]

    res = %w[evernote clint chardet keyring]
    res.each do |r|
      resource(r).stage { system "python", *install_args }
    end

    system "python", "setup.py", "install", "--prefix=#{prefix}"

    rm Dir["#{bin}/easy_install*"]
    rm "#{lib}/python2.7/site-packages/site.py"
    rm Dir["#{lib}/python2.7/site-packages/*.pth"]

    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/tover", "-v"
  end
end
