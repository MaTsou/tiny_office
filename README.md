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
        label: 'Invité',
      }
    },
    # etc.
  },
  # etc.
}

cloud_editor = TinyOffice::CloudEditor.new do |cloud_config, default_service_config|
  cloud_config.onlyoffice_url = ENV['ONLYOFFICE_URL']
  cloud_config.token_builder = jwt_encoder
  default_service_config.add(**editor_service_default_config)
  default_service_config.add(otherKey: value)
  # alternative syntax (use low level key as method name)
  default_service_config.editorConfig = editor_service_default_config[:editorConfig]
  default_service_config.otherKey = value
end
```
See [OnlyOfficeDocs](https://api.onlyoffice.com/docs/docs-api/usage-api/advanced-parameters/){:target="_blanck"} documentation to learn more about the editor `service_config` available contents.

Usage :

Syntax : `cloud_editor.call(service_name) { |service_config| # customize editor service config here }`

Example : to `edit` a document (for now the only supported service)  :
```
my_var = cloud_editor.call(:edit) do |service_config|
  service_config.add(
    document: {
      fileType: my_document_file_type,
      title: my_document_title,
      url: my_document_url,
      key: my_document_unique_key
    },
    editorConfig: {
      callbackUrl: my_callback_url,
    }
  )
  # alternative syntax (use root level key as method name)
  service_config.document = {
    fileType: my_document_file_type,
    title: my_document_title,
    url: my_document_url,
    key: my_document_unique_key
  }
  service_config.editorConfig = {
    callbackUrl: my_callback_url,
  }
end
```
Note that `service_config` will be **constructively** merged in 
`default_service_config` : taking care to override only existing last level 
keys..

```
# my-template.html.erb
<%== my_var.page_content %>
<script><%= my_var.js_inner_script.html_safe %></script>
```
will leads to an embeded OnlyOffice editor.

Notes :
+ Delivering the needed js code could be done in multiple ways :
  + First, you can replace `my_var.js_inner_script` by you own code
  + You can provide the TinyOffice original js code from cdn : just add 
    `cloud_config.tinyoffice_js_type = TinyOffice::JsType.cdn` to initial 
    config and remove `<script>` tag from your template.
  + Further, you can provide you own cdn source :
    ```
    cloud_config.tinyoffice_js_type = TinyOffice::JsType.cdn
    cloud_config.tinyoffice_js_cdn = "custom cdn url"
    ```
+ According to OnlyOfficeDocs documentation, the editor service config can 
  handle different events. I implemented one of these in `js` folder (to be completed) : this is `onRequestClose`. To configure which of these events you want to handle, you can add a `supported_events_level` entry to your config :
 ```
 # at initialization time
cloud_editor = TinyOffice::CloudEditor.new do |cloud_config, default_service_config|
   ...
   default_service_config.supported_events_level = TinyOffice::EventsLevel.full
 end
 # or when calling a service
 my_var = cloud_editor.call(:edit) do |service_config|
   ...
   service_config.supported_events_level = TinyOffice::EventsLevel.full
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
