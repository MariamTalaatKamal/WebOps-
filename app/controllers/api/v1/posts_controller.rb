# app/controllers/api/v1/posts_controller.rb

module Api
    module V1
      class PostsController < ApplicationController
        load_and_authorize_resource
        before_action :authenticate_user!
        before_action :set_post, only: [:show, :update, :destroy]
  
        def index
          @posts = Post.all
          render json: @posts
        end
  
        def show
          render json: @post
        end
  
        def create
            puts "Current User: #{current_user.inspect}"
          @post = current_user.posts.build(post_params)
  
          if @post.save
            render json: @post, status: :created
          else
            render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
          end
        end
  
        def update
          authorize! :update, @post
          puts "Current User: #{current_user.inspect}"
          unless current_user == @post.user
            render json: { error: "You don't have permission to update this post." }, status: :forbidden
            return
          end
  
          if @post.update(post_params)
            render json: @post
          else
            render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
          end
        end
  
        def destroy
          authorize! :update, @post
          unless current_user == @post.user
            render json: { error: "You don't have permission to delete this post." }, status: :forbidden
            return
          end
  
          @post.destroy
          head :no_content
        end
  
        private
  
        def set_post
          @post = Post.find(params[:id])
        end
  
        def post_params
          params.require(:post).permit(:title, :body, :tags)
        end
      end
    end
  end
  