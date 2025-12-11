module TinyOffice
  class Edit < Action
    payload_is_config

    default :document, {
      fileType: 'docx',
      title: 'Titre',
    }

    default :permissions, {
      edit: true,
      print: false,
    }

    default :supported_events_level, EventsLevel.full
    default :documentType, 'word'
  end
end
