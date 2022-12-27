FactoryBot.modify do
  factory :proposal_component do
    trait :with_moderation_enabled do
      step_settings do
        {
          participatory_space.active_step.id => { creation_enabled: true, moderation_enabled: true }
        }
      end
    end
    trait :with_moderation_amendment_enabled do
      step_settings do
        {
          participatory_space.active_step.id => { creation_enabled: true, moderation_enabled: true, moderation_amendment_enabled: true }
        }
      end
    end

    trait :with_moderation_comments_enabled do
      settings do
        {
          moderation_comments_enabled: true
        }
      end
    end

  end
end
