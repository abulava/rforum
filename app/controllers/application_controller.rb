class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to root_url
  end

  protected
    def load_topic(id)
      @topic = Topic.find_by_id(id)
      unless @topic
        flash[:alert] = 'Topic not found.'
        redirect_to topics_path(:page => params[:page])
      end
    end
end
