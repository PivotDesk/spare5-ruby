module Spare5
  class JobBatch

    REQUIRED_PARAMETERS = [:job_type, :name]

    # Deprecated: reward is set by the Spare5 server based on task type, and the value passed is ignored
    ATTRIBUTES = [:url, :name, :reward, :image_url, :callback_url, :instruction_pages, :job_type, :job_requester, :answer_options_json]

    JOB_TYPE_STAR_RATING = 'STARRATING'

    attr_accessor *ATTRIBUTES

    def initialize(json={})
      ATTRIBUTES.each do |key|
        self.send("#{key}=", json[key])
      end
    end

    def jobs(filters = {})
      response = Connection.get(self.url + '/jobs', filters)
      jobs = response[:result]

      jobs = jobs.map { |j| Job.new(j.merge(job_batch: self)) }

      jobs
    end

    def create_job!(job_or_job_params)
      create_job(job_or_job_params, true)
    end

    def create_job(job_or_job_params, raise_on_error = false)
      if job_or_job_params.is_a?(Spare5::Job)
        job = job_or_job_params
      else
        job = Job.new(job_or_job_params)
      end

      job.validate!(self.job_type)

      response = Connection.send_request(:post, raise_on_error, self.url + "/jobs", job.to_json)

      if response && response[:result]
        j = Job.new(response[:result])
        j.job_batch = self
        j
      else
        nil
      end
    end

    def responses(options = {})
      Response.load_responses(options.merge(job_batch: self))
    end

    def to_s
      ATTRIBUTES.map { |key| self.send(key) }.to_s
    end
  end
end
