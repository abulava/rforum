class MessagesController < ApplicationController
  before_filter :authenticate_user!, :except => :index
  before_filter :except => [:index] { |c| c.load_topic params[:topic_id] }
  before_filter :load_message, :only => :destroy

  def index
    @search = Message.search(params[:search])

    if search_attributes_set?
      @messages = @search.all.paginate(:page     => params[:page],
                                       :per_page => Message.per_page)
    else
      @messages = []
    end
  end

  def new
    @message = @topic.messages.new
    3.times do
      @message.attaches.build
    end

    @title = @topic.title
  end

  def create
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
    if @topic.messages.single_message?
      flash[:alert] = 'Single remaining message in a topic can\'t be destroyed.'
    else
      if current_user.admin? or current_user == @message.user
        @message.destroy
        flash[:notice] = 'Message destroyed.'
      end
    end

    redirect_page = [params[:page].to_i,@topic.messages.total_pages].min.nonzero?
    redirect_to topic_path(@topic, :page => redirect_page)
  end

  private
    def load_message
      @message = Message.find_by_id params[:id]
      unless @message
        flash[:alert] = 'Message not found.'
        redirect_to topic_path(@topic)
      end
    end

    def search_attributes_set?
      # TODO MetaSearch::Searches::ActiveRecord looks like right place for the method
      search_attributes = @search.search_attributes.select { |k,v| k != 'meta_sort' }
      !search_attributes.values.all?(&:blank?)
    end
end
