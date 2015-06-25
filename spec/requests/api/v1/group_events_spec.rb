require 'rails_helper'

describe 'Api::V1::GroupEventsController', type: :request do
  context 'create' do
    it 'create group event with draft state' do
      post '/api/v1/group_events.json', attributes_for(:group_event)
      expect(response.status).to eq 200
      expect(json['id']).to_not  be_nil
    end

    it 'not with validation error for wrong dates' do
      post "/api/v1/group_events.json",
           attributes_for(:group_event, start_on: '01-01-2015', finish_on: '01-01-2014')
      expect(response.status).to    eq 200
      expect(json['errors']).to_not be_nil
    end

    it 'with validation error for name' do
      post '/api/v1/group_events.json', attributes_for(:group_event, name: 'hello'*300)
      expect(response.status).to    eq 200
      expect(json['errors']).to_not be_nil
    end

    it 'with validation errors for description' do
      post '/api/v1/group_events.json', attributes_for(:group_event, description: 'hello'*60000)
      expect(response.status).to    eq 200
      expect(json['errors']).to_not be_nil
    end

    it 'with validation errors for location' do
      post '/api/v1/group_events.json', attributes_for(:group_event, location: 'hello'*300)
      expect(response.status).to    eq 200
      expect(json['errors']).to_not be_nil
    end
  end

  context 'update' do
    it 'name' do
      event    = create(:group_event)
      new_name = 'Fake name'
      patch "/api/v1/group_events/#{event.id}.json", {name: new_name}
      expect(response.status).to eq 200
      expect(json['msg']).to     eq I18n.t('group_events.ok')
      event.reload
      expect(event.name).to      eq new_name
    end

    it 'not with validation error for wrong dates' do
      event = create(:group_event)
      patch "/api/v1/group_events/#{event.id}.json", {start_on: '01-01-2015', finish_on: '01-01-2014'}
      expect(response.status).to    eq 200
      expect(json['errors']).to_not be_nil
    end
  end

  context 'publish' do
    it 'valid event' do
      event = create(:group_event)
      post "/api/v1/group_events/#{event.id}/publish.json"
      expect(response.status).to eq 200
      expect(json['msg']).to     eq I18n.t('group_events.ok')
    end

    it "and not because events haven't name" do
      event = create(:group_event, name: '')
      post "/api/v1/group_events/#{event.id}/publish.json"
      expect(response.status).to eq 200
      expect(json['error']).to     eq I18n.t('group_events.errors.blank_fields') << ' name'
    end

    it "and not because events haven't description" do
      event = create(:group_event, description: '')
      post "/api/v1/group_events/#{event.id}/publish.json"
      expect(response.status).to eq 200
      expect(json['error']).to     eq I18n.t('group_events.errors.blank_fields') << ' description'
    end

    it "and not because events haven't location" do
      event = create(:group_event, location: '')
      post "/api/v1/group_events/#{event.id}/publish.json"
      expect(response.status).to eq 200
      expect(json['error']).to     eq I18n.t('group_events.errors.blank_fields') << ' location'
    end

    it "and not because events haven't start date" do
      event = create(:group_event, start_on: '')
      post "/api/v1/group_events/#{event.id}/publish.json"
      expect(response.status).to eq 200
      expect(json['error']).to     eq I18n.t('group_events.errors.blank_fields') << ' start_on, duration'
    end

    it "and not because events haven't finish date and duration" do
      event = create(:group_event, finish_on: '', duration: '')
      post "/api/v1/group_events/#{event.id}/publish.json"
      expect(response.status).to eq 200
      expect(json['error']).to     eq I18n.t('group_events.errors.blank_fields') << ' finish_on, duration'
    end
  end

  context 'index' do
    it 'receive list of events' do
      create_list(:group_event, 10)
      get '/api/v1/group_events.json'
      expect(response.status).to eq 200
      expect(json['events'].count).to eq 10
    end
  end

  context 'show' do
    it 'fetch one event' do
      event = create(:group_event)
      get "/api/v1/group_events/#{event.id}.json"
      expect(response.status).to           eq 200
      expect(json['event']['name']).to        eq event.name
      expect(json['event']['description']).to eq event.description
      expect(json['event']['location']).to    eq event.location
      expect(json['event']['duration']).to    eq event.duration
      expect(Date.parse(json['event']['start_on'])).to    eq event.start_on
      expect(Date.parse(json['event']['finish_on'])).to   eq event.finish_on
    end

    it '404 error when page not found' do
      get '/api/v1/group_events/100.json'
      expect(response.status).to eq 404
    end
  end

  context 'destroy' do
    it 'but not really do it' do
      event = create(:group_event)
      delete "/api/v1/group_events/#{event.id}.json"
      expect(response.status).to eq 200
      event.reload
      expect(event.deleted_at).to_not be_nil
      expect(GroupEvent.count).to     eq 0
    end
  end

end