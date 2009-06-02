
Gem::Specification.new do |s|
  s.name = %q{pik}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Gordon Thiesfeld"]
  s.date = %q{2009-06-02}
  s.default_executable = %q{pik}
  s.description = %q{PIK, the ruby manager for windows}
  s.email = ["gthiesfeld@gmail.com"]
  s.executables = ["pik"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.txt", "Rakefile", "bin/pik", "lib/pik.rb", "lib/pik/batch_file.rb", "lib/pik/checkup.rb", "lib/pik/config.rb", "lib/pik/runner.rb", "lib/pik/search_path.rb", "lib/pik/windows_env.rb", "lib/pik/windows_file.rb", "messages/messages.yml", "spec/batch_file_spec.rb", "spec/search_path_spec.rb"]
  s.homepage = %q{http://github.com/vertiginous/pik/tree/master}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{pik}
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{PIK, the ruby manager for windows}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<highline>, [">= 0"])
      s.add_development_dependency(%q<hoe>, [">= 1.12.2"])
    else
      s.add_dependency(%q<highline>, [">= 0"])
      s.add_dependency(%q<hoe>, [">= 1.12.2"])
    end
  else
    s.add_dependency(%q<highline>, [">= 0"])
    s.add_dependency(%q<hoe>, [">= 1.12.2"])
  end
end
