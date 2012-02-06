class MessagesController < ApplicationController
  before_filter :authenticate_user!

  def new
    @topic = Topic.find(params[:topic_id])
    @message = @topic.messages.new
    3.times do
      @message.attaches.build
    end

    @title = @topic.title
  end

  def create
    @topic = Topic.find(params[:topic_id])
    @message = @topic.messages.build(params[:message])
    @message.user = current_user
    if @message.save
      flash[:notice] = 'Message created.'
      redirect_to topic_path(@topic, :page => @topic.messages.total_pages)
    else
      render 'new'
    end
  end

  def destroy
    @topic = Topic.find(params[:topic_id])
    if current_user.admin?
      @message = Message.find_by_id params[:id]
    else
      @message = current_user.messages.find_by_id params[:id]
    end

    if @message
      unless @topic.messages.last_message?
        @message.destroy
        flash[:notice] = 'Message destroyed.'
      else
        flash[:alert] = 'Last message in a topic can\'t be destroyed.'
      end
    else
      flash[:alert] = 'Message not found.'
    end

    redirect_page = [params[:page].to_i,@topic.messages.total_pages].min.nonzero?
    redirect_to topic_path(@topic, :page => redirect_page)
  end
end
