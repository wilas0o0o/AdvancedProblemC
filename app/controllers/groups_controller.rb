class GroupsController < ApplicationController
  before_action :ensure_correct_user, only: [:edit,:update]
  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    @group.users << current_user
    if @group.save
      redirect_to groups_path, notice: "You have created new group."
    else
      render :new
    end
  end

  def index
    @groups = Group.all
    @book = Book.new
  end

  def show
    @group = Group.find(params[:id])
    @group_members = @group.users.all
    @book = Book.new
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path, notice: "You have updated group."
    else
      render :edit
    end
  end

  def join
    @group = Group.find(params[:group_id])
    @group.users << current_user
    redirect_to groups_path, notice: "You have joined in group."
  end

  def leave
    @group = Group.find(params[:group_id])
    @group.users.delete(current_user)
    redirect_to groups_path, notice: "You have left group."
  end

  private
  def group_params
    params.require(:group).permit(:name,:introduction,:image)
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end
  end
end
