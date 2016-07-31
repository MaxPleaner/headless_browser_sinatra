=begin docs

- The MacroHelpers class is used by lib/sinatra_routes.rb
- It defines two constants on the Routes class: "Macro" and "CurrentMacro"
- It also defines the content for a few routes in its own "MacroRoutes" constant

= The macros feature is intended to record command sequences, save them, and replay them.

=end

module MacroHelpers

  def self.included(base)
    
    # Persistent storage
    base.const_set("Database", PStore.new("./database.pstore"))

    # Tracks if a macro is currently being recorded or not
    base.const_set("Macro", { status: nil })

    # Track the current macro before it is saved
    base.const_set("CurrentMacro", [])

  end
  
  def db
    self.class::Database
  end
  
  # content for /macro_on route
  def turn_macro_recording_on(given_params)
    if self.class::Macro[:status]
      message = "Cant turn macro on, it is already on"
    else
      self.class::CurrentMacro.clear
      self.class::Macro[:status] = "on"
      message = "Turned macro recording on"
    end
    @screenshot, @error = default_screenshot(message)
    return erb(:root)
  end

  def turn_macro_recording_off(given_params)
    if self.class::Macro[:status]
      self.class::Macro[:status] = nil
      message = "Turned macro recording off"
    else
      message = "Cant turn macro recording off, it is not on"
    end
    @screenshot, @error = default_screenshot(message)
    return erb(:root)
  end
  
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
      db.transaction { db[name] = Routes::CurrentMacro.to_json }
    end
    @screenshot, @error = default_screenshot(message)
    return erb(:root)
  end
  
  def all_macros
    results = {}
    # db.roots is like Hash#keys
    db.transaction { db.roots.each { |k| results[k] = JSON.parse(db[k]) } }
    return results
  end
  
end

