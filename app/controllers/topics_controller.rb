class TopicsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]
  before_filter :except => [:new, :create, :index] { |c| c.load_topic params[:id] }

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
    @messages = @topic.messages.sort_by_created_at_asc
                               .paginate(:page     => params[:page],
                                         :per_page => Message.per_page)
    @title = @topic.title
    @single_message = @topic.messages.single_message?
  end

  def edit
  end

  def update
    authorize! :update, @topic
    if @topic.update_attributes(params[:topic])
      flash[:notice] = 'Topic updated.'
      redirect_to root_path(:page => params[:page])
    else
      render 'edit'
    end
  end

  def destroy
    authorize! :destroy, @topic
    @topic.destroy
    flash[:notice] = 'Topic destroyed.'
    redirect_to topics_path(:page => params[:page])
  end
end
