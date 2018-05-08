module OverQuery
 def exec_queries
    if eager_group_values.present?
      EagerGroup::Preloader.new(self.klass, super, eager_group_values).run
    end
    super
  end
end

class ActiveRecord::Relation
  # Post.all.eager_group(:approved_comments_count, :comments_average_rating)

  prepend OverQuery

  def eager_group(*args)
    check_if_method_has_arguments!('eager_group', args)
    spawn.eager_group!(*args)
  end

  def eager_group!(*args)
    self.eager_group_values += args
    self
  end

  def eager_group_values
    @values[:eager_group] || []
  end

  def eager_group_values=(values)
    raise ImmutableRelation if @loaded
    @values[:eager_group] = values
  end
end
