# app/controllers/api/v1/comments_controller.rb
class Api::V1::CommentsController < ApplicationController
    before_action :authenticate_user!, only: [:create, :update, :destroy]
    before_action :set_post
    before_action :set_comment, only: [:update, :destroy]
  
    def index
      @comments = @post.comments
      render json: @comments
    end
  
    def create
      @comment = Comment.new(content: params[:content], post_id: params[:post_id], user_id: current_user.id)
      # @comment = @post.comments.new(comment_params)
      @comment.user = current_user
  
      if @comment.save
        render json: @comment, status: :created
      else
        render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def update
      authorize_comment_owner!
  
      if @comment.update(content: params[:content])
        render json: @comment
      else
        render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def destroy
      authorize_comment_owner!
  
      @comment.destroy
      head :no_content
    end
  
    private
  
    def set_post
      @post = Post.find(params[:post_id])
    end
  
    def set_comment
      @comment = @post.comments.find(params[:id])
    end
  
    def comment_params
      params.require(:comment).permit(:body)
    end
  
    def authorize_comment_owner!
      unless @comment.user == current_user
        render json: { error: 'You are not authorized to perform this action' }, status: :unauthorized
      end
    end
  end
  