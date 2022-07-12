class UsersController < ApplicationController
  before_action :set_user, only: %i[ show update destroy ]

  def index
    if current_user.role == "admin"
      @users = User.all
      render json: @users
    else
      render status: :forbidden
    end
  end

  def show
    render json: @user
  end

  def create
    if current_user.role == "admin"
      @user = User.new(user_params)

      if @user.save!
        render json: { 
            status: {code: 200, message: "Admin successfully created a user."},
        }
      else
        render json: @user.errors, status: :unprocessable_entity
      end

    else
      render status: :forbidden
    end
  end

  def update
    if current_user.role == "admin"
      @user = User.find(params[:id])
      @user.update(email: user_params[:email])
      @user.update(password: user_params[:password])
      @user.update(name: user_params[:name])
      @user.update(phone_number: user_params[:phone_number])
      @user.update(role: user_params[:role])
      if @user.save!
        render json: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    else
      render status: :forbidden
    end
  end

  def destroy
    if current_user.role == "admin"
      @user.destroy
      render json: {
        status: {code: 200, message: 'Delete successful.'},
      }
    else
      render status: :forbidden
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :phone_number, :role, :password)
    end
end

