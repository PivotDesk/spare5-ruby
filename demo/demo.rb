require 'spare5-ruby'

TEST_BATCH_NAME = 'Test star rating'
TEST_REFERENCE_ID = 1234

# setup JobRequester with credentials (or it will look in ENV vars by default)
requester = Spare5::JobRequester.new(spare5_username: ENV['SPARE5_USERNAME'], spare5_token: ENV['SPARE5_TOKEN'])
puts "connected! #{requester}"

# load all batches associated with this account
all_batches = requester.job_batches
puts "Job batch count = #{all_batches.length}"

test_batch = requester.job_batches(name: TEST_BATCH_NAME).first
if !test_batch
  test_batch = requester.create_job_batch(name: TEST_BATCH_NAME, reward: 0.02, job_type: Spare5::JobBatch::JOB_TYPE_STAR_RATING)
end
puts "test_batch #{test_batch}"

jobs = test_batch.jobs
puts "Job count = #{jobs.length}"

# Make sure it doesn't exist before creating it. This avoids getting an error if you're retrying an import
test_job = test_batch.jobs(reference_id: TEST_REFERENCE_ID).first

if test_job
  puts "job with reference_id #{TEST_REFERENCE_ID} already in the test batch. #{test_job.inspect}"
else
  puts "job with reference_id #{TEST_REFERENCE_ID} not found in the test batch, creating new job"
  # Some job types can have multiple questions or question_images, but most job types have just 1 question and 1 image
  job_params = {
      num_responders: 3,
      reference_id: TEST_REFERENCE_ID,
      questions:
        [
          {
            reference_url: "http://www.spare5.com/companies",
            hints: ["Don''t run", "turn off the lights"],
            answer_options: ['Red', 'Green', 'Blue'],
            is_multi_select: false,
            question_images:
              [
                {
                  name: 'My image',
                  description: 'Lots of info about my image',
                  original_url: 'http://cdn.sheknows.com/articles/2013/04/Puppy_3.jpg',
                }
              ]
          }
        ]
    }

  test_job = test_batch.create_job!(job_params)
end

# get answers for a single job
answers = test_job.answers
puts "test job has #{answers.length} answers"

# all answers for a batch
answers = test_batch.answers
puts "test batch has #{answers.length} answers"

# or all answers from any batches (sorted by most recent first)
answers = requester.answers
puts "requester has #{answers.length} answers (in the first page any way)"
