class CommentsController < ApplicationController
  before_action :authenticate_user!
  # load_and_authorize_resource
  before_action :set_comment, only: %i[show edit update destroy]
  before_action :set_blog, only: %i[index new]

  def index
    @comment = Comment.recent_first.where(blog_id: @blog.id)
    respond_to do |format|
      format.json { render json: @comment, status: 200 }
      format.html
    end
  end

  def show

  end

  def new
    @comment = current_user.comments.new(blog_id: @blog.id)
  end

  def create
    @comment = current_user.comments.new(comment_params)
    respond_to do |format|
      if @comment.save
        format.html { redirect_to blog_path(@comment.blog_id), notice: "Comment has been Added successfully " }
        format.json { render json: @comment.to_json, status: :created }
      else
        format.html { redirect_to new_comment_path, alert: @comment.errors.full_messages.join("</br>") }
        format.json { render json: @comment.errors, status: 404 }
      end
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
       format.html { redirect_to blog_path(@comment.blog_id), notice: "Comment has been updated successfully" }
       format.json { render json: @comment.to_json }
      else
        format.html { redirect_to edit_comment_path, alert: @comment.errors.full_messages.join("</br>")  }
        format.json { render json: @comment.errors }
      end
    end
  end

  def destroy
    # if @comment.destroy
    #   redirect_to comments_path(blog_id: @comment.blog_id), notice: "Comment has been deleted successfully"
    # end
    redirect_to comments_path(blog_id: @comment.blog_id), notice: "Comment has been deleted successfully" if @comment.destroy
  end

  private

  def comment_params
   params.expect(comment: [ :comment, :blog_id, :user_id ])
  end

  def set_comment
   # @comment = current_user.blogs.comments.find_by(id: params[:id])
   @comment = Comment.find_by(id: params[:id])
  end

  def set_blog
    @blog = Blog.find(params[:blog_id])
  end
end
