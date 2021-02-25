# frozen_string_literal: true

module GroupTitles
  class Categories
    include ::ProductsFilters

    attr_accessor :group_title, :data, :category

    def perform
      ActiveModelSerializers::SerializableResource.new(GroupTitle.includes(:categories).all,
                                                       each_serializer: ::Categories::GroupTitlesSerializer)
                                                  .as_json.reject { |title| title[:categories].size.zero? }
    end
  end
end
