class MessagesController < ApplicationController
  before_filter :authenticate_user!

  def new
    @topic = Topic.find(params[:topic_id])
    @message = @topic.messages.new
  end

  def create
    @topic = Topic.find(params[:topic_id])
    @message = @topic.messages.build(params[:message])
    @message.user = User.first # @wip
    if @message.save
      redirect_to topic_path(@topic)
    else
      render 'new'
    end
  end

  def destroy
    @message = current_user.messages.find params[:id]
    @message.destroy
    flash[:success] = 'Success'
    redirect_to topic_path(@message.topic)
  end
end
