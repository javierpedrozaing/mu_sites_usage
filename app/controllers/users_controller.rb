class UsersController < ApplicationController
  load_and_authorize_resource
  
  def index
    @title = "#{current_user.department.display_name} Users"
  end

  def new
    @title = "New User"
  end

  def create
    if current_user.administrator? && params[:user][:department_id].present?
      @department = Department.find(params[:user][:department_id])
    end
    @department ||= current_user.department
    @user = @department.users.build(params[:user]) 
    if @user.save
      flash[:success] = "Successfully added #{@user.name}"
      redirect_to users_path
    else
      @title = "New User"
      render 'new'
    end
  end
    
  def edit
    @title = "Edit user"
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { 
          flash[:success] = "User successfully updated."
          redirect_to(users_path) 
        }
        format.json { respond_with_bip(@user) }
      else
        format.html { 
          @title = "Edit User"
          render :action => "edit" 
        }
        format.json { respond_with_bip(@user) }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    if !current_user?(@user)
      @user.destroy
      flash[:success] = "User remove."
    else
      flash[:error] = "Cannot remove yourself."
    end
    redirect_to users_path
  end

end
