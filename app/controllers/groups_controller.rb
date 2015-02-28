class GroupsController < ApplicationController
  before_action :ensure_logged_in!

  def index
    @groups = current_user.groups
    @group = Group.new
  end

  def edit
    @group = current_user.groups.find(params[:id])
  end

  def update
    @group = current_user.groups.find(params[:id])
    if @group.update_attributes(group_params)
      redirect_to groups_path
    end
  end

  def create
    @group = current_user.groups.new(group_params)
    if @group.save
      redirect_to groups_path
    end
  end

  def destroy
    @group = current_user.groups.find(params[:id])
    if !@group.default? && @group.destroy
      redirect_to groups_path
    end
  end

  private

    def group_params
      params.require(:group).permit(:title)
    end

end
