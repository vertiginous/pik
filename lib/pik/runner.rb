module Pik

  class Runner

    def add_gem_home(*patterns)
      to_add = get_version
      new_dir = @options[:default] ? Gem.default_path.first : @hl.ask("Enter a path to a GEM_HOME dir")
      if @hl.agree("Add a GEM_HOME and GEM_PATH for '#{to_add}'? [Yn] ")
        @config[to_add][:gem_home] = new_dir
        @hl.say("GEM_HOME and GEM_PATH added for:  #{to_add} ")
      end
    end

  end

end
