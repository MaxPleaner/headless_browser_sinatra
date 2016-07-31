=begin docs

- The MacroHelpers class is used by lib/sinatra_routes.rb
- It defines two constants on the Routes class: "Macro" and "CurrentMacro"
- It also defines the content for a few routes in its own "MacroRoutes" constant

 The macros feature is intended to record command sequences, save them, and replay them.

=end

# MacroRunner class, assists with replaying macros
require_relative("./macro_runner.rb")

module MacroHelpers
  
  include MacroRunner

  def self.included(base)
    
    # Persistent storage
    base.const_set("Database", PStore.new("./database.pstore"))

    # Tracks if a macro is currently being recorded or not
    base.const_set("Macro", { status: nil })

    # Track the current macro before it is saved
    base.const_set("CurrentMacro", [])
    
    # Track which macro is currently running, if any
    base.const_set("RunningCommand", { name: "", cmd: [] })

  end
  
  def db
    self.class::Database
  end
  
  # saves params to the CurrentMacro list
  def add_to_current_macro(params_obj)
    if params_obj.values.any?
      self.class::CurrentMacro.push(params_obj)
    end
  end
  
  
  # content for /macro_on route
  def turn_macro_recording_on(given_params)
    if self.class::Macro[:status]
      message = "Cant turn macro on, it is already on"
    else
      self.class::CurrentMacro.clear # empties array
      self.class::Macro[:status] = "on"
      message = "Turned macro recording on"
    end
    @screenshot, @error = default_screenshot(message)
    @macros = all_macros
    return erb(:root)
  end

  # content for /macro_off route
  def turn_macro_recording_off(given_params)
    if self.class::Macro[:status]
      self.class::Macro[:status] = nil
      message = "Turned macro recording off"
    else
      message = "Cant turn macro recording off, it is not on"
    end
    @screenshot, @error = default_screenshot(message)
    @macros = all_macros
    return erb(:root)
  end
  
  # content for /macro_save route
  def save_current_macro(given_params)
    name = given_params[:name].to_s.gsub(" ", "-")
    if name.empty?
      message = "Macro name can't be empty"
      failure = true
    elsif self.class::CurrentMacro.empty?
      message = "Current macro has no content"
      failure = true
    elsif self.class::Macro[:status]
      message = "Can't save macro while recording"
      failure = true
    else
      db.transaction { db[name] = YAML.dump(Routes::CurrentMacro) }
    end
    @screenshot, @error = default_screenshot(message)
    @macros = all_macros
    return erb(:root)
  end
  
  # provides a list of macro objects which is displayed by root.erb
  def all_macros
    results = {}
    db.transaction { db.roots.each { |k| results[k] = YAML.load(db[k]) } }
    return results
  end
  
  # content for /macro_edit route
  def edit_macro(params_obj)
    name = params_obj[:name]
    macro = []
    db.transaction { macro = YAML.load(db[name]) }
    if macro
      @macro_name = name
      @macro_content = YAML.dump(macro)
      return erb(:edit_macro)
    else
      @screenshot, @error = default_screenshot("Macro not found by that name")
      @macros = all_macros
      return erb(:root)
    end
  end
  
  def macro_content_is_valid?(macro_content)
    macro_content.is_a?(Array) &&\
    macro_content.all? { |obj| obj.is_a?(Hash) }
  end
  
  def macro_update_error_msg(msg)
    "Error: #{msg}<br>
    Did not update macro.<br>
    Please fix macro and try again"
  end
  
  # content for /macro_update route
  def update_macro(params_obj)
    @macro_name = params_obj[:name]
    yaml_content = params_obj[:content]
    begin
      parsed_content = YAML.load(yaml_content)
      if macro_content_is_valid?(parsed_content)
        @macro_content = YAML.dump(parsed_content)
        db.transaction { db[@macro_name] = @macro_content }
        @message = "updated #{@macro_name} macro"
      else
        @message = macro_update_error_message(
          "content is not an array of hashes"
        )
        @failed_macro_edit = YAML.dump(parsed_content)
      end
    rescue Psych::SyntaxError => e # an error relating to YAML parsing
      @message = macro_update_error_msg(e)
      @failed_macro_edit = yaml_content
    end
    return erb(:edit_macro)
  end
  
  # content for /macro_delete route
  def delete_macro(params_obj)
    name = params_obj[:name]
    found_macro = []
    db.transaction { found_macro = db[name] }
    if found_macro
      db.transaction { db.delete(name) }
      message = "deleted macro #{name}"
    else
      message = "failed to delete macro #{name}: it couldn't be found"
    end
    @screenshot, @error = default_screenshot(message)
    @macros = all_macros
    return erb(:root)
  end
  
  # content for /macro_play route
  def replay_macro(params_obj)
    name = params_obj[:name]
    found_macro = []
    db.transaction { found_macro = YAML.load(db[name]) }
    if found_macro
      add_macro_to_current_macro(name) if self.class::Macro[:status]
      return start_running_macro(name, found_macro) # defined in macro_runner
    else
      @screenshot, @error = default_screenshot(
        "Can't replay that macro. It couldn't be found."
      )
      return erb(:root)
    end
  end
  
  # macro nesting
  def add_macro_to_current_macro(name)
    self.class::CurrentMacro.push({'macro' => name})
  end
  
  def continue_macro_run
    return continue_running_macro # defined in macro_runner
  end
  
end

