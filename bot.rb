require 'bundler/setup'
require 'sinatra'
require 'twilio-ruby'
require 'dialog-api'

require 'active_support/core_ext/hash'

# Load environment variables from .env
require 'dotenv'
Dotenv.load

# Helpers to handle tracking with Dialog
class DialogTwilio

  def initialize(client)
    @client = client
  end

  # @param params [Hash]
  def incoming(params)
    payload = {
      message: {
        distinct_id: params['MessageSid'],
        sent_at: Time.now.to_f,
        properties: {
          text: params['Body']
        },
      },
      creator: {
        distinct_id: params['From'],
        type: 'interlocutor'
      }
    }.deep_merge(dialog_attributes(params))

    @client.track(payload)
  end

  # @param params [Hash]
  # @param message [String]
  def outgoing(params, message)
    payload = {
      message: {
        distinct_id: SecureRandom.uuid,
        sent_at: Time.now.to_f,
        properties: {
          text: message
        }
      },
      creator: {
        distinct_id: 'bot_id',
        type: 'bot'
      }
    }.deep_merge(dialog_attributes(params))

    @client.track(payload)
  end

  private

  # @param params [Hash]
  def dialog_attributes(params)
    {
      message: {
        platform: 'sms',
        provider: 'twilio',
        mtype: 'text'
      },
      conversation: {
        distinct_id: (params['From'] + params['To']).strip
      }
    }
  end
end

# Create a Dialog API client
client = Dialog.new({
  api_token: ENV,fetch('DIALOG_API_TOKEN'),
  bot_id: ENV,fetch('DIALOG_BOT_ID'),
  on_error: Proc.new do |status, message, detail|
    p [status, message, detail]
  end
})

# Create a Dialog tracking helper
dialog = DialogTwilio.new(client)

# Receive a SMS
#
# Twilio payload:
#
#   {
#     "ToCountry"=>"CA",
#     "ToState" => "Québec",
#     "SmsMessageSid" => "SM031adc20211f6bdc0533cb93c53ac57f",
#     "NumMedia" => "0",
#     "ToCity" => "",
#     "FromZip" => "",
#     "SmsSid" => "SM031adc20211f6bdc0533cb93c53ac57f",
#     "FromState" => "QC",
#     "SmsStatus" => "received",
#     "FromCity" => "QUEBEC",
#     "Body" => "Hugh",
#     "FromCountry" => "CA",
#     "To"=>"+1 58 17004296",
#     "ToZip" => "",
#     "NumSegments" => "1",
#     "MessageSid" => "SM031adc20211f6bdc0533cb93c53ac57f",
#     "AccountSid" => "ACaf464a215129ea7cd739c2a948672250",
#     "From" => "+14185800893",
#     "ApiVersion" => "2010-04-01"
#   }
post '/sms' do
  content_type 'text/xml'

  # Track incoming message
  dialog.incoming(params)

  response = Twilio::TwiML::Response.new do |res|
    message = "Gotcha!"

    # Track outgoing message
    dialog.outgoing(params, message)

    res.message message
  end

  response.to_xml
end
