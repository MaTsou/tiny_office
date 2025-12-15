require_relative 'test_helper'

describe TinyOffice::ServiceConfiguration do
  describe 'on setting' do
    before do
      @conf = TinyOffice::ServiceConfiguration.new
      @to_be_constructed = {
        hello: 'world',
        to: 'you',
        and: 'me',
        for: 'the_best',
        and_also: 'the_worst'
      }
    end

    it 'add entries to content with \"add\" method' do
      @conf.add(hello: 'world')
      @conf.add(to: 'you', and: 'me')
      @conf.add(**{ for: 'the_best', and_also: 'the_worst' })

      _(@conf.content).must_equal @to_be_constructed
    end

    it 'add entries to content with \"missing_method\"' do
      @conf.hello = 'world'
      @conf.to = 'you'
      @conf.and = 'me'
      @conf.for = 'the_best'
      @conf.and_also = 'the_worst'

      _(@conf.content).must_equal @to_be_constructed
    end
  end

  describe 'on fine merge' do
    before do
      @a = TinyOffice::ServiceConfiguration.new
      @a.add(
        document: { title: 'hello world', type: 'docx' },
        editor: {
          lang: 'fr',
          custom: {
            close: {
              visible: true,
              text: 'La ferme'
            },
            another: 'Yeh !'
          }
        }
      )

      @b = TinyOffice::ServiceConfiguration.new
      @b.add(
        event: 'new key',
        document: { title: 'hello world', type: 'changed_type' },
        editor: {
          lang: 'en',
          custom: {
            close: {
              visible: true,
              text: 'Close it now'
            },
          }
        }
      )

      @b_fine_merged_in_a = TinyOffice::ServiceConfiguration.new
      @b_fine_merged_in_a.add(
        event: 'new key',
        document: { title: 'hello world', type: 'changed_type' },
        editor: {
          lang: 'en',
          custom: {
            close: {
              visible: true,
              text: 'Close it now'
            },
            another: 'Yeh !'
          }
        }
      )
    end

    it 'correctly works' do
      _(@a.fine_merge(@b)).must_equal @b_fine_merged_in_a
    end
  end
end
