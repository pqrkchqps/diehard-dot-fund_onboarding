module Plugins
  module DiehardFundOnboarding
    class Plugin < Plugins::Base
      setup! 'diehard-dot-fund_onboarding' do |plugin|
        plugin.enabled = true
        plugin.use_component :group_progress_card, outlet: [:before_group_page_column_right, :before_thread_page_column_right]
        # plugin.use_component :user_progress_card, outlet: :after_user_username

        plugin.use_translations 'config/locales', :diehard_fund_onboarding

        plugin.use_test_route(:setup_progress_card_coordinator) do
          GroupService.create(group: create_group, actor: patrick)
          test_subgroup = Group.new(name: 'Johnny sub',
                                    parent: create_group,
                                    discussion_privacy_options: 'public_or_private',
                                    group_privacy: 'closed')
          GroupService.create(group: test_subgroup, actor: patrick)
          create_group.update_attribute(:description, 'Here is a group description')
          create_group.cover_photo = File.new("#{Rails.root}/spec/fixtures/images/strongbad.png")
          create_group.save
          patrick.avatar_kind = 'gravatar'
          patrick.save
          sign_in patrick
          create_discussion
          redirect_to group_url(create_group)
        end

        plugin.use_test_route(:setup_progress_card_member) do
          sign_in jennifer
          redirect_to group_url(create_group)
        end
      end
    end
  end
end
