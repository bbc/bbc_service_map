Gem::Specification.new do |s|
  s.name = %q{bbc_service_map}
  s.version = "0.0.4"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sean O'Halpin"]
  s.date = %q{2011-05-16}
  s.description = <<-EOT
Map between the multiplicity of BBC service identifiers for radio and TV
EOT
  s.email = %q{sean.ohalpin@bbc.co.uk}
  s.files = Dir["lib/**"] + Dir["config/**"]
  s.has_rdoc = false
  s.homepage = %q{http://github.com/bbc/bbc_service_map}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{bbc_service_map}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{BBC Radio and TV Service Identifier Mappings}
end
