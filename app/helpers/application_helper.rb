module ApplicationHelper
  def react(name, args={})
    react_component(name, args, prerender: true)
  end

  def react_js(name, args={})
    react_component(name, args)
  end
end
