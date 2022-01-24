# name: x-discourse-assign
# about: Pavilion assign extension
# version: 0.1.0
# authors: Angus McLeod
# url: https://github.com/paviliondev/x-discourse-assign

after_initialize do
  on(:topic_created) do |topic, opts, user|
    assignments = {}
    SiteSetting.pavilion_plugin_assignments.split('|').each do |i|
      parts = i.split(':')
      assignments[parts.first] = parts.last
    end

    plugin = (topic.tags.pluck(:name) & assignments.keys).first
    if plugin
      assigner = Assigner.new(topic, Discourse.system_user)
      assigner.assign(User.find_by_username(assignments[plugin]))
    end
  end
end
