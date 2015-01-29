module Spare5
  class Job
    REQUIRED_PARAMETERS = [:num_responders]
    ATTRIBUTES = [:url, :num_responders, :num_completed, :finished, :reference_id, :job_batch]

    attr_accessor *ATTRIBUTES

    attr_accessor :questions

    def initialize(json={})
      ATTRIBUTES.each do |key|
        self.send("#{key}=", json[key.to_s])
      end

      self.questions = json['questions']
    end

    def responses(options = {})
      Response.load_responses(options.merge(job: self))
    end

    def to_s
      ATTRIBUTES.map { |key| self.send(key) }.to_s
    end
  end
end
