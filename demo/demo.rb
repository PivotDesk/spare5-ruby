require 'spare5-ruby'
require 'spare5-ruby/job_types/star_rating'
TEST_BATCH_NAME = 'Test star rating'
TEST_REFERENCE_ID = 1234

# setup JobRequester with credentials (or it will look in ENV vars by default)
requester = Spare5::JobRequester.new(api_username: ENV['SPARE5_USERNAME'], api_token: ENV['SPARE5_TOKEN'])
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

  j = Spare5::StarRatingJob.new(
      'num_responders' => 3,
      'reference_id' => TEST_REFERENCE_ID,
      'star_hints' => ['Terrible', 'Poor', 'Average', 'Good', 'Excellent'],
      'image_url' => 'http://cdn.sheknows.com/articles/2013/04/Puppy_3.jpg',
  )

  test_job = test_batch.create_job!(j)
end

# get responses for a single job
responses = test_job.responses
puts "test job has #{responses.length} responses"

# all responses for a batch
responses = test_batch.responses
puts "test batch has #{responses.length} responses"

# or all responses from any batches (sorted by most recent first)
responses = requester.responses
puts "requester has #{responses.length} responses (in the first page any way)"
