class BlogsController < ApplicationController
  before_action :authenticate_user!
  # load_and_authorize_resource
  # authorize_resource :class => false
  # load_and_authorize_resource
  before_action :set_blog, only: %i[show edit update destroy]
  # before_action :authorized_user, only: %i[edit update destroy]

  def index
    @blogs = Blog.recent_first.paginate(page: params[:page], per_page: 5)
    respond_to do |format|
      format.json { render json: @blogs, status: 200  }
      format.html { render :index }
    end
  end

  def new
    @blog = current_user.blogs.new
  end

  def create
    @blog = current_user.blogs.new(blog_params)
    respond_to do |format|
      if @blog.save
        format.html { redirect_to blogs_path, notice: "Blog has been created successfully" }
        format.json { render json: @blog, status: :created }
      else
        format.html { redirect_to new_blog_path, alert: @blog.errors.full_messages.join("</br>") }
        format.json { render json: @blog.errors }
      end
    end
  end

  def show
     respond_to do |format|
      format.json { render json: @blog }
      format.html
      end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @blog.update(blog_params)
        format.html { redirect_to blogs_path, notice: "Blog has been updated successfully" }
        format.json { render json: @blog, status: :updated }
      else
        redirect_to edit_blog_path, alert: @blog.errors.full_messages.join("</br>")
      end
    end
  end

  def destroy
    respond_to do |format|
      if current_user
        if @blog.destroy
        format.html { redirect_to blogs_path }
        format.json { render json: @blog }
        end
      else
        puts "not a current user"
      end
    end
  end

  private

  def authorized_user
    redirect_to blogs_path, alert: "You are can't modify this post" unless @blog.user == current_user
  end

  def set_blog
    @blog = Blog.find(params[:id])
  end

  def blog_params
   params.expect(blog: [ :title, :content, :image ])
  end
end
