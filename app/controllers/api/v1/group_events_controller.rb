class Api::V1::GroupEventsController < Api::V1::ApplicationController
  before_action :set_event, only: [:show, :publish, :destroy, :update]

  def index
    render json: { events: GroupEvent.all }
  end

  def create
    event = GroupEvent.new(event_params)
    if event.save
      render json: { id: event.id }
    else
      render json: { errors: event.errors.full_messages }
    end
  end

  def show
    render json: { event: @event }
  end

  def update
    if @event.update(event_params)
      render_ok
    else
      render json: { errors: @event.errors.full_messages }
    end
  end

  def destroy
    @event.destroy
    render_ok
  end

  def publish
    if @event.publish!
      render_ok
    else
      render json: { error: t('group_events.errors.blank_fields') << ' ' << @event.blank_fields.join(', ') }
    end
  end

  private

  def render_ok
    render json: { msg: t('group_events.ok') }
  end

  def set_event
    @event = GroupEvent.find(params[:id])
  end

  def event_params
    params.permit(:name, :description, :location, :start_on, :finish_on, :duration)
  end
end
