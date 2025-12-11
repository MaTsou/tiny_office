module TinyOffice
  class Edit < EditorService
    payload_is_config

    default :document, to: {
      fileType: 'docx',
      title: 'Titre',
    }

    default :permissions, to: {
      edit: true,
      print: false,
    }

    default :supported_events_level, to: EventsLevel.full
    default :documentType, to: 'word'
  end
end
