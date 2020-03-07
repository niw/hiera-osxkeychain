lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name = "hiera-osxkeychain"
  spec.version = "0.1.1"
  spec.authors = ["Yoshimasa Niwa"]
  spec.email = ["niw@niw.at"]
  spec.description = spec.summary = "Hiera backend for looking up OS X keychain"
  spec.homepage = "https://github.com/niw/hiera-osxkeychain"
  spec.license = "MIT"

  spec.extra_rdoc_files = `git ls-files -z -- README* LICENSE`.split("\x0")
  spec.files = `git ls-files -z -- lib/*`.split("\x0") + spec.extra_rdoc_files

  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "test-unit"
  spec.add_development_dependency "mocha"
end
