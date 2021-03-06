module ApplicationHelper
  def error_messages_for(object)
    render "application/error_message", object: object
  end
  def present(object,klass= nil)
    klass ||="#{object.class}Presenter".constantize
    presenter=klass.new(object, self)
    yield presenter if block_given?
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def notify_count

  end
end
