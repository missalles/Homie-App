class SwapsController < ApplicationController
  def index
    @invitations = Swap.where(user_two: current_user).where(status: "pending")
    @requests = Swap.where(user_one: current_user).where(status: "pending")
    @swaps = Swap.where("user_one_id = #{current_user.id} or user_two_id = #{current_user.id}").where(status: "accepted")
  end

  def create
    @user_two = User.find(params[:user_two_id])
    @swap = Swap.create(user_one: current_user, user_two: @user_two, status: "pending")
    if @swap.save!
      flash[:notice] = "You sent a Swap request to #{@user_two.first_name}"
      redirect_to users_path
    else
      flash[:notice] = "You failed to send a Swap request to #{@user_two.first_name}"
      redirect_to users_path
    end
  end

  def update
    @swap = Swap.find(params[:id])
    @swap.update(status: "accepted")
    @chatroom = Chatroom.create(swap: @swap)
    flash[:notice] = "You accepted the Swap request from #{@Swap.user_one.first_name}"
    redirect_to chatroom_path(@chatroom)
  end

  def destroy
    @swap = Swap.find(params[:id])
    @swap.destroy
    redirect_to Swaps_path
  end
end
