class TransactionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @q = Transaction.ransack(params[:q])
    @pagy, @transactions = pagy(@q.result.order(created_at: :desc), items: 5)
  end

  def new
    @wallets = Wallet.where.not(user: current_user)
    @transaction_types = Transaction.transaction_types
    @from = current_user.wallet.id
  end

  def create
    begin
      ActiveRecord::Base.transaction do
        amount = params[:amount].to_i
        transaction_type = params[:transaction_type]
        wallet_source_balance = wallet_source.balance_cents
        wallet_target_balance = wallet_target.balance_cents

        if transaction_type == 'transfer'
          wallet_source.update!(balance: wallet_source_balance - amount)
          wallet_target.update!(balance: wallet_target_balance + amount)
        end

        if transaction_type == 'deposit'
          wallet_source.update!(balance: wallet_source_balance - amount)
          wallet_target.update!(balance: wallet_target_balance + amount)
        end

        if transaction_type == 'withdraw'
          wallet_source.update!(balance: wallet_source_balance - amount)
        end

        Transaction.create!(
          amount: params[:amount],
          from: wallet_source,
          to: wallet_target,
          transaction_type: transaction_type
        )

        redirect_to transactions_path, notice: "Success create transaction"
      end
    rescue ActiveRecord::RecordInvalid
      redirect_to transactions_path, notice: "Failed create transaction"
    end
  end

  private
  def wallet_source
    wallet_source = Wallet.find_by_id(params[:from])
  end

  def wallet_target
    wallet_target = Wallet.find_by_id(params[:to])
  end
end
