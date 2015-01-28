module Spare5
  class JobRequester
    def initialize(options = {})
      Connection.api_username = options[:api_username] || ENV['SPARE5_USERNAME']
      Connection.api_token = options[:api_token] || ENV['SPARE5_TOKEN']
      Connection.base_url = options[:base_url] || ENV['SPARE5_BASE_URL'] || 'http://app.spare5.com/partner/v2/'
    end

    def job_batches(filters = {})
      job_batches = Connection.get('job_batches', filters)

      job_batches = job_batches.map { |jb| JobBatch.new(jb.merge('job_requester' => self)) }
      job_batches.select! { |jb| jb.name == filters[:name] } if filters[:name]
      job_batches.select! { |jb| jb.job_type == filters[:job_type] } if filters[:job_type]

      job_batches
    end

    def create_job_batch(params)
      JobBatch::REQUIRED_PARAMETERS.each do |key|
        return { error: "#{key.to_s} required" } if !params[key]
      end

      result = Connection.post('job_batches', params)

      if result
        JobBatch.new(result)
      else
        nil
      end
    end

    def answers(options = {})
      Answer.load_answers(options)
    end

    def to_s
      Connection.to_s
    end
  end
end
