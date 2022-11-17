class Transaction < ApplicationRecord
  belongs_to :from, :class_name => 'Wallet', :foreign_key => :from_id
  belongs_to :to, :class_name => 'Wallet', :foreign_key => :to_id

  validates :amount, presence: true, numericality: true
  validates :transaction_number, presence: true, uniqueness: true
  validates :transaction_type, presence: true

  before_validation :load_defaults

  enum transaction_type: {
    debit: 'debit',
    credit: 'credit',
    withdraw: 'withdraw'
    deposit: 'deposit'
  }

  private
    def load_defaults
      if self.new_record?
        self.transaction_number = SecureRandom.uuid
      end
    end
end
