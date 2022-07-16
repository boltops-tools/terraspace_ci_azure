# frozen_string_literal: true

require_relative "lib/terraspace_ci_azure/version"

Gem::Specification.new do |spec|
  spec.name = "terraspace_ci_azure"
  spec.version = TerraspaceCiAzure::VERSION
  spec.authors = ["Tung Nguyen"]
  spec.email = ["tung@boltops.com"]

  spec.summary = "Terraspace CI Azure support"
  spec.homepage = "https://github.com/boltops-tools/terraspace_ci_azure"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/boltops-tools/terraspace_ci_azure"
  spec.metadata["changelog_uri"] = "https://github.com/boltops-tools/terraspace_ci_azure/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|azure)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "zeitwerk"
end