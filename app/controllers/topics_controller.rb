class TopicsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]

  def new
    render :text => "'New' stub"
  end
  
  def create
    render :text => "'Create' stub"
  end

  def index
    @topics = Topic.paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @topic = Topic.find(params[:id])
    @messages = @topic.messages.paginate(:page => params[:page], :per_page => 5)
    @title = @topic.title
  end

  def destroy
    render :text => "'Delete' stub"
  end
end
