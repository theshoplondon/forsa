class MembershipApplication
  ##
  # The main place we define steps and their acceptable parameters,
  # with some helper methods to tell us where we are.
  class Steps
    include Singleton

    PARAMS = ActiveSupport::OrderedHash[{
      'about-you'              => [:title, :first_name, :last_name, :gender, :date_of_birth],
      'contact-details'        => [:email, :phone_number, :home_address],
      'your-work'              => [:job_title, :employer, :work_address, :payroll_number,
                                   :department_section, :school_roll_number, :technical_grade],
      'your-subscription-rate' => [:pay_rate, :pay_unit, :hours_per_week, :applicant_saw_monthly_estimate],
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
