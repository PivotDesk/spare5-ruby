module Spare5
  class StarRatingJob < Job
    def initialize(options)
      # convert hints to json_option_answer format
      hints = options['star_hints'] ? options['star_hints'].map.with_index { |hint, index| { type: 'item', id: index + 1, text: hint, } } : nil

      options.merge!(
        'questions' =>
            [
                {
                    'answer_options_json' => hints,
                    'is_multi_select' => false,
                    'question_images' =>
                        [
                            {
                                'original_url' => options[:image_url],
                            }
                        ]
                }
            ]
      )

      super(options)
    end

    def validate!(job_type)
      raise if job_type != JobBatch::JOB_TYPE_STAR_RATING
      super(job_type)
    end
  end

  # may add StarRatingResponse and other job_type specific classes here
end