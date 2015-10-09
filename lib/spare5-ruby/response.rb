module Spare5
  class Response
    ATTRIBUTES = [:response_url, :job_url, :job_batch_url, :question_id, :user_id, :response, :reference_id, :created_at,
                  :image_url, :answer_summary, :num_responders, :num_completed, :best_response, :best_score]

    attr_accessor *ATTRIBUTES

    def initialize(json={})
      ATTRIBUTES.each do |key|
        self.send("#{key}=", json[key])
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
      responses = response[:result]
      responses.map { |a| Response.new(a) }
    end
  end
end
