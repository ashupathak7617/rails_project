class CommentsController < ApplicationController
  
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_comment, only: %i[update destroy]

  def index
    @comment = Comment.where(blog_id: params[:blog_id])
    respond_to do |format|
      format.json{ render json: @comment, status: 200}
      format.html
    end
  end

  def new
    @comment = current_user.comments.new(blog_id: params[:blog_id])   
  end

  def create
    @comment = current_user.comments.new(comment_params)
    respond_to do |format|
      if @comment.save
        format.html {redirect_to blogs_path, notice: "Comment has been Added successfully"}
        format.json{ render json: @comment.to_json, status: :created}
      else
        format.html{redirect_to new_comment_path, alert: @comment.errors.full_messages.join("</br>")}
        format.json{ render json: @comment.errors, status: 404}
      end
    end
  end

  def edit; end

  def update

    respond_to do |format|
      if @comment && @comment.update(comment_params)
       format.html { redirect_to comments_path(blog_id: @comment.blog_id), notice: "Comment has been updated successfully" }
       format.json { render json: @comment.to_json }
      else
        format.html { redirect_to edit_comment_path, alert: @comment.errors.full_messages.join("</br>")  }
        format.json {render json: @comment.errors}
      end
    end
  end

  def destroy
    if @comment.destroy
      redirect_to comments_path(blog_id: @comment.blog_id), notice: "Comment has been deleted successfully"
    end
  end 

  private

  def comment_params
   params.expect(comment: [:comment, :blog_id])
  end

  def set_comment
    @comment = Comment.find_by(id: params[:id])
  end
end
