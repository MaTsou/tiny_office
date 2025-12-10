module TinyOffice
  module Wrapper
    class FullPage
      FRAME_CLASS="doc-frame-wrapper"
      HTML_STYLE="html{width:100%;height:100%;}"
      BODY_STYLE=[
        "body{",
        "width:100%;",
        "height:100%;",
        "overflow:hidden;",
        "display:flex;",
        "flex-direction:column;",
        "margin:0",
        "}"
      ].join
      FRAME_STYLE=[
        ".#{FRAME_CLASS}{",
        "width:100%;",
        "height:100%;",
        "overflow-y:auto;",
        "display:flex;",
        "flex:1 1 100%;",
        "}"
      ].join

      def call(action, cloud_config)
        @cloud_config = cloud_config
        @action = action
        [
          style_part,
          html_part,
          js_part
        ].join
      end

      private
      attr_reader :cloud_config, :action

      def style_part
        "<style>#{HTML_STYLE}#{BODY_STYLE}#{FRAME_STYLE}</style>"
      end

      def html_part
        [
          %Q(<div id="oo_placeholder" class="#{FRAME_CLASS}">),
          %Q(<div style="display: none;" id="oo_config">#{action.config}</div>),
          %Q(</div>)
        ].join
      end

      def js_part
        js_files.map do |js|
          "<script src=#{js} cross-origin=\"anonymous\"></script>"
        end.join
      end

      def js_files
        [
          "#{cloud_config.onlyoffice_url}web-apps/apps/api/documents/api.js",
          cloud_config.onlyoffice_js_cdn
        ]
      end
    end
  end
end
