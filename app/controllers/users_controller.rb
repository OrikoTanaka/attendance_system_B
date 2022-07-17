class UsersController < ApplicationController
   before_action :set_user, only: [:show, :edit, :update, :edit_basic_info, :update_basic_info]
   before_action :logged_in_user, only: [:index, :show, :edit, :update, :edit_basic_info, :update_basic_info]
   before_action :correct_user, only: [:edit, :update]
   before_action :admin_user, only: [:edit_basic_info, :update_basic_info]
   before_action :set_one_month, only: :show
   
  def index
    if params[:search].present?
      @users = User.where('name LIKE ?', "%#{params[:search]}%").paginate(page: params[:page]) # paginate内の処理なので、どちらの場合にもpaginateを指定しないといけない。
    else
      @users = User.paginate(page: params[:page])
    end
  end
  
  def show
    @worked_sum = @attendances.where.not(started_at: nil).count
  end
 
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user 
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "アカウント情報を更新しました。"
      redirect_to @user
    else
      render :edit
    end
  end
  
  def edit_basic_info
  end
  
  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
    else
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
    end
    
    def basic_info_params
      params.require(:user).permit(:department, :basic_time, :work_time)
    end
end
