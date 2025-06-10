Gem::Specification.new do |s|
  s.name        = "BeagleByte"
  s.version     = "0.1.0"
  s.summary     = "A tech site for Jekyll"
  s.license     = "MIT"
  s.files       = Dir["{_layouts,_includes,assets}/**/*", "LICENSE.txt", "README.md"]
  s.add_runtime_dependency "jekyll", "~> 4.0"
end