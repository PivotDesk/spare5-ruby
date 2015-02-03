module Spare5
  class Job
    REQUIRED_PARAMETERS = [:num_responders]
    ATTRIBUTES = [:url, :num_responders, :num_completed, :finished, :reference_id, :job_batch]

    attr_accessor *ATTRIBUTES

    attr_accessor :questions

    def initialize(json={})
      ATTRIBUTES.each do |key|
        self.send("#{key}=", json[key])
      end

      self.questions = json[:questions]
    end

    def responses(options = {})
      Response.load_responses(options.merge(job: self))
    end

    def save_to_batch(job_batch)
      job_batch.create!(self.to_json)
    end

    def to_json
      result = {}
      ATTRIBUTES.each { |key| v = self.send(key) ; result[key] = v if v }
      result[:questions] = self.questions
      result
    end

    def validate!(job_type)
      REQUIRED_PARAMETERS.each do |key|
        raise "#{key.to_s} required" if !self.send(key)
      end

      raise "Need at least 1 question" if !self.questions || self.questions.length == 0
    end

    def to_s
      ATTRIBUTES.map { |key| self.send(key) }.to_s
    end
  end
end
