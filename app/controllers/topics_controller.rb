class TopicsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]

  def new
    @topic = current_user.topics.new
    @topic.messages.build
  end
  
  def create
    @topic = current_user.topics.build(params[:topic])
    @topic.messages[0].user = current_user

    if @topic.save
      flash[:notice] = 'Topic created.'
      redirect_to root_path
    else
      render 'new'
    end
  end

  def index
    @topics = Topic.all_by_newest_message
                   .paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @topic = Topic.find(params[:id])
    @messages = @topic.messages.paginate(:page     => params[:page],
                                         :per_page => Message.per_page)
    @title = @topic.title
    @last_message = @topic.messages.last_message?
  end

  def destroy
    render :text => "'Delete' stub"
  end
end
