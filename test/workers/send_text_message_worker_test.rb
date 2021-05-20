require "test_helper"

class SendTextMessageWorkerTest < ActiveSupport::TestCase
  test "perform" do
    text = create(:text_message, status: "ready", direction: "outbound",
                                 number: "+13038752721", body: "test text message")

    VCR.use_cassette :twilio_send_text_message do
      SendTextMessageWorker.new.perform(text.id)
    end

    text.reload

    assert text.queued?
    assert_equal "SM1e199f963e96497ba17cd6df6709ce9a", text.provider_id
  end
end
