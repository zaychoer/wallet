class TransactionsController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def transactions_params
    params.require(:transaction).permit(:avatar, :name, :email, :password, :password_confirmation)
  end
end
