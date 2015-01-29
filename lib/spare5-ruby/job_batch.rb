module Spare5
  class JobBatch
    REQUIRED_PARAMETERS = [:job_type, :name, :reward]
    ATTRIBUTES = [:url, :name, :reward, :image_url, :callback_url, :instruction_pages, :job_type, :job_requester]

    JOB_TYPE_STAR_RATING = 'STARRATING'

    attr_accessor *ATTRIBUTES

    def initialize(json={})
      ATTRIBUTES.each do |key|
        self.send("#{key}=", json[key.to_s])
      end
    end

    def jobs(filters = {})
      response = Connection.get(self.url + '/jobs', filters)
      jobs = response['result']

      jobs = jobs.map { |j| Job.new(j.merge('job_batch' => self)) }

      jobs
    end

    def create_job!(params)
      create_job(params.merge(raise_on_error: true))
    end

    def create_job(params)
      raise_on_error = params.delete(:raise_on_error)
      Job::REQUIRED_PARAMETERS.each do |key|
        return { error: "#{key.to_s} required" } if !params[key]
      end

      question_params = params[:questions]
      return { error: "Need at least 1 question" } if !question_params || question_params.length == 0

      response = Connection.send_request(:post, raise_on_error, self.url + "/jobs", params)
      result = response['result']

      if result
        j = Job.new(result)
        j.job_batch = self
        j
      else
        nil
      end
    end

    def responses(options = {})
      Response.load_responses(options.merge(job_batch: self))
    end
  end
end