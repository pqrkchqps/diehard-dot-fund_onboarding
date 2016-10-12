module Plugins
  module LoomioGroupProgressBar
    class Plugin < Plugins::Base
      setup! :loomio_group_progress_card do |plugin|
        plugin.enabled = true
        plugin.use_component :group_progress_card, outlet: :before_group_column_right
        plugin.use_translations 'config/locales', :group_progress_card

        plugin.use_test_route(:setup_progress_card_coordinator) do
          GroupService.create(group: test_group, actor: patrick)
          test_group.update_attribute(:enable_experiments, true)
          test_group.update_attribute(:description, 'Here is a group description')
          test_group.cover_photo = File.new("#{Rails.root}/spec/fixtures/images/strongbad.png")
          test_group.save
          patrick.avatar_kind = 'gravatar'
          patrick.save
          sign_in patrick
          test_discussion
          redirect_to group_url(test_group)
        end
        plugin.use_test_route(:setup_progress_card_member) do
          test_group.update_attribute(:enable_experiments, true)
          sign_in jennifer
          redirect_to group_url(test_group)
        end
      end
    end
  end
end