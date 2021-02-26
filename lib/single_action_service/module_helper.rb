module SingleActionService::ModuleHelper
  def module_parent
    module_parent_name ? constantize(module_parent_name) : Object
  end

  def constantize(string)
    string.split('::').inject(Object) do |module_object, class_name|
      module_object.const_get(class_name)
    end
  end

  def module_parent_name
    if defined?(@parent_name)
      @parent_name
    else
      parent_name = name =~ /::[^:]+\z/ ? -$` : nil
      @parent_name = parent_name unless frozen?
      parent_name
    end
  end
end
