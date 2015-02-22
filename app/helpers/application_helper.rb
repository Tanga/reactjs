module ApplicationHelper
  def react(name, args={})
    react_component(name, args, prerender: true)
  end
end
