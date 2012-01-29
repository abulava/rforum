class MessagesController < ApplicationController
  before_filter :authenticate_user!

  def new
    @topic = Topic.find(params[:topic_id])
    @message = @topic.messages.new
  end

  def create
    @topic = Topic.find(params[:topic_id])
    @message = @topic.messages.build(params[:message])
    @message.user = current_user
    if @message.save
      redirect_to topic_path(@topic)
    else
      render 'new'
    end
  end

  def destroy
    @message = current_user.messages.find params[:id]
    @message.destroy
    flash[:notice] = 'Message destroyed.'
    redirect_to topic_path(@message.topic)
  end
end
