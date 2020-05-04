FactoryBot.define do
  factory :membership_application do
    sequence(:email) { |n| "person#{n}@zephyros-systems.co.uk" }

    first_name { 'Natalie' }

    trait(:abandoned) do
      step_about_you

      created_at { 25.hours.ago }
    end

    trait(:bad_email) do
      email { 'we_dont_like@mailinator.com' } # Would 400 on Mailchimp
    end

    trait(:step_new) {}

    ##
    # Note each of the below traits creates a valid object.
    #
    # To create an object with invalid attributes, first create
    # a valid one then subtract things.
    trait :step_about_you do
      step_new

      current_step { 'about-you' }

      first_name    { 'Natalie' }
      last_name     { 'Zurbman' }
      gender        { 'female' }
      date_of_birth { '19/04/1973' }
    end

    trait :step_contact_details do
      step_about_you

      current_step { 'contact-details' }

      phone_number { '02345678' }
      job_title    { 'Accountant' }
      home_address { '21 Plankton Road' }
    end

    trait :step_your_work do
      step_contact_details

      current_step { 'your-work' }

      employer       { 'Office of Public Works' }
      work_address   { 'Somewhere' }
      payroll_number { '1234' }
    end

    trait :step_your_subscription_rate do
      step_your_work

      current_step { 'your-subscription-rate' }

      pay_rate       { '35000' }
      pay_unit       { 'year' }
    end

    trait :step_declaration do
      step_your_subscription_rate

      current_step { 'declaration' }

      declaration { 'Natalie Zurbman' }
    end
  end
end
