module Spare5
  class Answer
    ATTRIBUTES = [:job_id, :job_batch_id, :question_id, :user_id, :response, :reference_id, :created_at]

    attr_accessor *ATTRIBUTES

    def initialize(json={})
      ATTRIBUTES.each do |key|
        self.send("#{key}=", json[key.to_s])
      end
    end

    # implementing here because it's used from various models
    def self.load_answers(filters = {})
      case
        when filters[:job]
          path = "job_batches/#{filters[:job].job_batch.id}/jobs/#{filters[:job].id}/answers"
        when filters[:job_batch]
          path = "job_batches/#{filters[:job_batch].id}/answers"
        else
          path = 'answers'
      end

      response = Connection.get(path)
      answers = response['result']
      answers.map { |a| Answer.new(a) }
    end
  end
end
