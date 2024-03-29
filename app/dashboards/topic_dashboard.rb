require "administrate/base_dashboard"

class TopicDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    parent: Field::BelongsTo.with_options(class_name: "Topic"),
    children: Field::HasMany.with_options(class_name: "Topic"),
    visual_exploration: Field::BelongsTo,
    presentations: Field::HasMany,
    products: Field::HasMany,
    id: Field::Number,
    name: Field::String,
    description: Field::Text,
    force_subnavigation: Field::Boolean,
    parent_id: Field::Number,
    position: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :position,
    :name,
    :parent,
    :children,
    :presentations,
    :products,
    :id,
  ]

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :position,
    :parent,
    :children,
    :presentations,
    :products,
    :id,
    :name,
    :description,
    :parent_id,
    :force_subnavigation,
    :created_at,
    :updated_at,
  ]

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :position,
    :parent,
    :children,
    :presentations,
    :name,
    :description,
    :force_subnavigation,
    :visual_exploration
  ]

  # Overwrite this method to customize how topics are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(topic)
  #   "Topic ##{topic.id}"
  # end
  def display_resource(topic)
    "#{topic.name} (#{topic.id})"
  end
end
