class CommentsController < ApplicationController
  before_action :set_project

  def index
    @comments=Comment.all
  end

  def new
    @comment=Comment.new
    @comment.notifications.build
  end

  def create
    @comment=@project.comments.new(comment_params)
    if @comment.save
      #binding.pry
      if @comment.content =~/\@/
        #binding.pry
        name=@comment.content.partition('@').last.partition(" ").first
        AdminMailer.send_mail(name).deliver_later
        notification=@comment.notifications.create(notify_name: "New Comment mention #{comment_params[:content]}", recipient: name)
        ActionCable.server.broadcast 'notifications_channel', notification: notification.notify_name, count: Notification.all.count, recipient: name

      end
      #AdminMailer.send_mail("jmscb56@gmail.com").deliver
      redirect_to @project, flash: { success: "commented !" }
    else
      redirect_to @project, flash: { danger: "Comment Creation Failed!!" }
    end
  end

    private
    def set_project
      @project=Project.find(params[:project_id])
    end

    def comment_params
      params.require(:comment).permit(:content, :category, :commenter_name, notifications_attributes: [:notify_name])
    end
end
