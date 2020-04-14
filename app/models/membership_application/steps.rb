class MembershipApplication
  class Steps
    include Singleton

    PARAMS = ActiveSupport::OrderedHash[{
      'about-you'              => [:title, :first_name, :last_name, :gender, :date_of_birth],
      'contact-details'        => [:email, :phone_number, :home_address],
      'your-work'              => [:job_title, :employer, :work_address, :payroll_number],
      'your-subscription-rate' => [:pay_rate, :pay_unit, :hours_per_week],
      'declaration'            => [:declaration]
    }]

    def step_names
      PARAMS.keys
    end

    def index_of(step)
      @index_of ||= step_names.each_with_index.map { |name, index| [name, index] }.to_h
      @index_of[step]
    end

    def reached_step?(application_step, step)
      return false if application_step.nil?
      index_of(application_step) >= index_of(step)
    end
  end
end
