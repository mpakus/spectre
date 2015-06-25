require 'rails_helper'

describe GroupEvent, type: :model do
  context 'validations' do
    it 'check name limits' do
      event = build(:group_event, name: 'hello'*300)
      event.valid?
      expect(event.errors[:name]).to include('is too long (maximum is 255 characters)')
    end

    it 'check description limits' do
      event = build(:group_event, description: 'hello'*65000)
      event.valid?
      expect(event.errors[:description]).to include('is too long (maximum is 65535 characters)')
    end

    it 'check location limits' do
      event = build(:group_event, location: 'hello'*300)
      event.valid?
      expect(event.errors[:location]).to include('is too long (maximum is 255 characters)')
    end

    it 'check if finish date is early than start date' do
      event = build(:group_event, start_on: '01-01-2015', finish_on: '01-01-2014')
      event.valid?
      expect(event.errors[:finish_on]).to include I18n.t('group_events.errors.finish_early_than_start')
    end
  end

  context 'dates' do
    it 'calculate duration from finish and start dates' do
      event = create(:group_event, start_on: '01-01-2015', finish_on: '31-01-2015')
      expect(event.duration).to eq 31
    end

    it 'calculate finish from start date and duration' do
      event = create(:group_event, start_on: '01-01-2015', duration: 31, finish_on: nil)
      expect(event.finish_on).to eq Date.parse('31-01-2015')
    end
  end

  context 'state' do
    it 'is default state draft' do
      event = create(:group_event)
      expect(event.state.to_sym).to eq :draft
    end

    it 'changed to published when all fields exists' do
      event = create(:group_event)
      event.publish!
      expect(event.publish!).to     be_truthy
      expect(event.state.to_sym).to eq :published
    end

    it 'raise exception when can not publish event with empty fields' do
      event = create(:group_event, location: '')
      expect(event.publish!).to     be_falsey
      expect(event.state.to_sym).to eq :draft
    end
  end

  context 'destroy' do
    it 'is hide item only' do
      event = create_list(:group_event, 5)
      event[1].destroy
      event[1].reload
      expect(event[1].deleted_at).to_not be_nil
      expect(GroupEvent.count).to eq 4
    end
  end
end
