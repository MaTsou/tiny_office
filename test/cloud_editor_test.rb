require 'json'
require_relative 'test_helper'

ROOT_SERVICE_CFG = {
  'editor' => { 'lang' => 'fr', 'custom' => { 'close' => { 'visible' => true, 'text' => 'Hi there' } } }
}
EDIT_SERVICE_CFG = {
  'editor' => { 'lang' => 'en' }, 'event' => 'you'
}
SERVICE_CFG = {
  'document' => 'hello', 'event' => 'me'
}

class TinyOffice::Fakeservice < TinyOffice::EditorService
  payload_is_config

  configure do |cfg|
    cfg.add(**EDIT_SERVICE_CFG)
  end
end

describe TinyOffice::CloudEditor do
  before do
    @cloud_editor = TinyOffice::CloudEditor.new do |cloud_cfg, root_srv_cfg|
      cloud_cfg.token_builder = ->(cfg) { 'token' }
      root_srv_cfg.add **ROOT_SERVICE_CFG
    end

    @service = @cloud_editor.call(:fakeservice) do |cfg|
      cfg.add **SERVICE_CFG
    end
  end

  it 'correctly handles EditorService config' do
    _(TinyOffice::EditorService.configuration.content).must_equal ROOT_SERVICE_CFG
  end

  it 'correctly handles Edit config' do
    _(TinyOffice::Fakeservice.configuration.content).must_equal EDIT_SERVICE_CFG
  end

  it 'correctly handles Edit instance config' do
    expected = TinyOffice::ServiceConfiguration::ExtendedHash[ROOT_SERVICE_CFG].
      fine_merge(EDIT_SERVICE_CFG).
      fine_merge(SERVICE_CFG)

    result = JSON.parse(@service.config).tap { |r| r.delete('token') }

    _(result).must_equal expected
  end
end
