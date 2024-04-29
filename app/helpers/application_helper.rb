module ApplicationHelper
  def inline_button(label, path, method = :get)
    opts = { form: { style: "display:inline-block;" } }
    opts[:method] = method if method
    button_to label, path, opts
  end
end
