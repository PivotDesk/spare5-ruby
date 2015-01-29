module Spare5
  class Response
    ATTRIBUTES = [:job_id, :job_batch_id, :question_id, :user_id, :response, :reference_id, :created_at]

    attr_accessor *ATTRIBUTES

    def initialize(json={})
      ATTRIBUTES.each do |key|
        self.send("#{key}=", json[key.to_s])
      end
    end

    # implementing here because it's used from various models
    def self.load_responses(filters = {})
      case
        when filters[:job]
          path = filters[:job].url + '/responses'
        when filters[:job_batch]
          path = filters[:job_batch].url + '/responses'
        else
          path = Connection.base_url + 'responses'
      end

      response = Connection.get(path)
      responses = response['result']
      responses.map { |a| Response.new(a) }
    end
  end
end
