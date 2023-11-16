# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "jekyll-string-theory"
  spec.version       = "0.1.1"
  spec.authors       = ["LunaRoseManor"]
  spec.email         = ["lunarosemanor@gmail.com"]

  spec.summary       = "The smallest jekyll theme in the universe!"
  spec.homepage      = "https://github.com/LunaRoseManor/jekyll-string-theory"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r!^(assets|_data|_layouts|_includes|_sass|LICENSE|README|_config\.yml)!i) }

  spec.add_runtime_dependency "jekyll", "~> 4.3"
end
