# Twilio SMS Ruby Chatbot

An example [Twilio SMS](https://twilio.com) Ruby chatbot integrated with [Dialog Analytics](https://dialoganalytics.com). Built with [twilio/twilio-ruby](https://github.com/twilio/twilio-ruby).

- [Dialog Documention](https://docs.dialoganalytics.com)
- [Dialog API reference](https://docs.dialoganalytics.com/reference)

## Getting started

Clone this repository and run `bundle install`

Create an account on https://app.dialoganalytics.com, grab your Dialog API token and bot ID.

Set environment variables in `.env`:

```
DIALOG_API_TOKEN=...
DIALOG_BOT_ID=...
```

Get your Twilio Account SID and Auth Token from http://www.twilio.com/console

Get a Twilio phone number from http://www.twilio.com/console/phone-numbers, create a Programmable SMS service and set the __inbound settings__ request url to the endpoint on which this server will be listening: this should be something like `https://f562681e.ngrok.io/sms`.

__Local development:__ When developping locally, use a service like https://ngrok.com to expose a server running on your machine.

```bash
$ ngrok http 4567
```

Start the bot:

```bash
$ ruby bot.rb
```

Send a SMS to the phone number you defined previously. Messages will be sent to Dialog's API.

## Go further

Read more on how to make the most out of the possibilities offered by Dialog here: https://dialoganalytics.com
