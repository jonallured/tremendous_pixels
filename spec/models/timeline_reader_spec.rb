require 'rails_helper'

def enqueued_jobs
  ActiveJob::Base.queue_adapter.enqueued_jobs
end

describe TimelineReader do
  describe ".read" do
    context "with no tweets" do
      it "does nothing" do
        client = double(:client, user_timeline: [])
        expect(TwitterClient).to receive(:generate).and_return client
        TimelineReader.read('username')

        expect(TargetTweet.count).to eq 0
        expect(enqueued_jobs.count).to eq 0
      end
    end

    context "with duplicate tweets" do
      it "does nothing" do
        tweet = double(:tweet, id: "1a2b3c", full_text: 'hi')
        client = double(:client, user_timeline: [tweet])
        expect(TwitterClient).to receive(:generate).and_return client

        target_tweet = TargetTweet.create twitter_id: tweet.id, full_text: 'hi'
        TimelineReader.read('username')

        expect(TargetTweet.count).to eq 1
        expect(enqueued_jobs.count).to eq 0
      end
    end

    context "with a brand new tweet" do
      it "creates a TargetTweet and enqueues a TransformTweetJob" do
        tweet = double(:tweet, id: '1a2b3c', full_text: 'hi')
        client = double(:client, user_timeline: [tweet])
        expect(TwitterClient).to receive(:generate).and_return client
        TimelineReader.read('username')

        expect(TargetTweet.count).to eq 1
        expect(enqueued_jobs.count).to eq 1
      end
    end

    context "with no TargetTweet records" do
      it "does not pass the since_id argument to Twitter" do
        client = double :client
        timeline_args = {
          exclude_replies: false,
          include_rts: false,
          trim_user: true
        }
        expect(client).to receive(:user_timeline).with('username', timeline_args).and_return([])
        expect(TwitterClient).to receive(:generate).and_return client
        TimelineReader.read('username')
      end
    end
  end
end
