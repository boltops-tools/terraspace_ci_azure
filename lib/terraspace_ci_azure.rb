# frozen_string_literal: true

require "terraspace_ci_azure/autoloader"
TerraspaceCiAzure::Autoloader.setup

require "json"

module TerraspaceCiAzure
  class Error < StandardError; end
end

require "terraspace"
Terraspace::Cloud::Ci.register(
  name: "azure",
  env_key: "SYSTEM_TEAMFOUNDATIONSERVERURI",
  root: __dir__,
  exe: ".azure/bin", # terraspace new ci NAME generator will make files in this folder executable
)
