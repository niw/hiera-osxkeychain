lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name = "hiera-osxkeychain"
  spec.version = "0.1.0"
  spec.authors = ["Yoshimasa Niwa"]
  spec.email = ["niw@niw.at"]
  spec.homepage = "https://github.com/niw/hiera-osxkeychain"
  spec.description = spec.summary = "Hiera backend for looking up OS X keychain"

  spec.extra_rdoc_files = `git ls-files -- README* LICENSE`.split($/)
  spec.files = `git ls-files -- lib/*`.split($/) + spec.extra_rdoc_files

  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "test-unit"
  spec.add_development_dependency "mocha"
end
