
# module Pik
  
#   class Default < Command
  
#     it "Switches back to the default settings."
  
#     attr_accessor :verbose
  
#     include ScriptFileEditor
  
#     def execute
#       default = config.global[:default]
#       raise PrettyError, "You have to configure the default" unless default
#       switch_path_to(@config[default])
      
#       if gemset 
#         gem_home = gemset_gem_home(default, gemset)
#         raise GemSetMissingError.new(gemset) unless gem_home.exist?
#       end
#       gem_home ||= @config[default][:gem_home]
      
#       switch_gem_home_to(gem_home)
#       echo_ruby_version(@config[default][:path]) if verbose
#     end
    
#     def command_options
#       super
#       options.on("--verbose", "-v",
#          "Verbose output"
#          ) do |value|
#         @verbose = value
#       end
#       options.on("--gemset=gemset", "-@",
#          "Use gem set"
#          ) do |value|
#         @gemset = value
#       end
#     end
  
#   end

# end
