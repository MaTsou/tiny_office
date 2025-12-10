# TinyOffice
A tiny gem to make my ruby saas app handle an onlyoffice docs cloud.

## Installation

This gem is not on `rubygems.org`. To install it, add
```
gem 'tiny_office', github: "MaTsou/tiny_office"
```
to your Gemfile and run `bundle install`.

## Usage
First you must have a running onlyoffice docs cloud.

Environment variables (provided after subscription to onlyoffice cloud) :
```
ONLYOFFICE_URL=https://yyyyxxxx.docs.onlyoffice.com/ # idem
JWT_HEADER=AutorizationJwt
JWT_SECRET=xxx
```

Initialization and default editor configuration :
```
require 'tiny_office'

jwt_encoder = TinyOffice::JwtEncoder.new(
  secret: ENV['JWT_SECRET'],
  header: ENV['JWT_HEADER']
)

editor_service_default_config = {
  editorConfig: {
    lang: 'fr',
    coEditing: {
      mode: 'fast',
      change: true
    },
    customization: {
      anonymous: {
        request: true,
        label: "Invité",
      }
    },
    # etc.
  },
  # etc.
}

cloud_editor = TinyOffice::CloudEditor.new do |cloud_config|
  cloud_config.onlyoffice_url = ENV['ONLYOFFICE_URL']
  cloud_config.token_builder = jwt_encoder
  cloud_config.editor_service_config = editor_service_default_config
end
```
See [OnlyOfficeDocs](https://api.onlyoffice.com/docs/docs-api/get-started/how-it-works/opening-file/) documentation to learn more about the `editor service config` available contents.

Usage :

Syntax : `cloud_editor.call(supported_method) { |config| # customize editor service config here }`

Example : to `edit` a document (for now the only supported method)  :
```
my_var = cloud_editor.call(:edit) do |config|
  config.document = {
    fileType: my_document_file_type,
    title: my_document_title,
    url: my_document_url,
    key: my_document_unique_key
  }
  config.editorConfig = {
    callbackUrl: my_callback_url,
  }
end
```

`my_var` now contains an `OnlyOffice` object. Insert `<%= my_var.page_content 
%>` inside any html template and you will have a OnlyOffice editor embeded 
in your page.

Notes :
+ According to OnlyOfficeDocs documentation, the editor service config can 
  handle different events. I implemented one of these in `js` folder (to be completed) : this is `onRequestClose`. To configure which of these events you want to set, you can add a `supported_events_level` entry to your config :
 ```
 my_var = cloud_editor.call(:edit) do |config|
   config.supported_events_level: TinyOffice::EventsLevel.full
 end
 ```
 Other possible methods to `EventsLevel` are `read_only` and `no_event`.
## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/tiny_office.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
