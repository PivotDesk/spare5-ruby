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

    def create_job!(job)
      create_job(job, true)
    end

    def create_job(job, raise_on_error)
      job.validate!(self.job_type)

      response = Connection.send_request(:post, raise_on_error, self.url + "/jobs", job.to_json)
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