module PresentationsHelper
  class TopicsNav
    def initialize(view:, controller:)
      @view = view
      @topics = Topic.where(parent_id: nil)
      @controller = controller
    end

    def html
      content_tag :nav do
        safe_join(nav_content)
      end
    end

    private

    attr_accessor :view
    delegate :link_to, :content_tag, :safe_join, :concat, to: :view

    def nav_content
      @topics.collect do |topic|
        concat(main_topic(topic))
      end
    end

    def main_topic(topic)
      content_tag :div, class: 'well' do
        main_topic_link(topic).concat(child_topics(topic.children))
      end
    end

    def main_topic_link(main_topic)
      link_to(content_tag(:span, main_topic.name, class: 'name'),
              controller: @controller,
              topic_ids: main_topic.id
             )
    end

    def child_topics(children)
      content_tag :ul, class: 'category' do
        children.collect do |child_topic|
          concat(child_link(child_topic))
        end
      end
    end

    def child_link(child_topic)
      content_tag :li do
        link_to(child_topic.name,
                controller: @controller,
                topic_ids: child_topic.id,
               )
      end
    end
  end
end
