class MembershipApplication
  class Steps
    include Singleton

    PARAMS = ActiveSupport::OrderedHash[{
      'about-you'       => [:title, :first_name, :last_name, :date_of_birth],
      'contact-details' => [:email, :phone_number],
      'work-and-pay'    => [:job_title, :employer, :work_address, :payroll_number, :pay_rate, :pay_unit],
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
