# Twilio SMS Ruby Chatbot

An example [Twilio SMS](https://twilio.com) Ruby chatbot integrated with [Dialog Analytics](https://dialoganalytics.com). Built with [twilio/twilio-ruby](https://github.com/twilio/twilio-ruby).

## Getting started

Clone this repository and run `bundle install`

Create an account on https://app.dialoganalytics.com, grab your Dialog API token and bot ID.

Set environment variables in `.env`:

```
DIALOG_API_TOKEN=...
DIALOG_BOT_ID=...
```

Get your Twilio Account SID and Auth Token from www.twilio.com/console

Get a Twilio phone number from www.twilio.com/console/phone-numbers and set the webhook callback to the endpoint on which this server will be listening.

__Local development:__ When developping locally, use a service like ngrok.com to expose a server running on your machine. This should be something like `https://f562681e.ngrok.io/sms`

```bash
$ ngrok http 3000
```

Start the bot:

```bash
$ ruby bot.rb
```

Send a SMS to the phone number you defined previously. Messages will be sent to Dialog's API.

# Go further

Read more on how to make the most out of the possibilities offered by Dialog here: https://docs.dialoganalytics.com
