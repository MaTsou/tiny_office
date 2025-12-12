module TinyOffice
  class Edit < EditorService
    payload_is_config

    configure do |config|
      config.document = {
        fileType: 'docx',
        title: 'Titre',
      }
      config.permissions = {
        edit: true,
        print: false,
      }
      config.supported_events_level = EventsLevel.full
      config.documentType = 'word'
    end
  end
end
