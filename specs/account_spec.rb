
require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/skip_dsl'
require_relative '../lib/account'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

describe "Wave 1" do
  describe "Account#initialize" do
    it "Takes an ID and an initial balance" do
      id = 1337
      balance = 100.0
      account = Bank::Account.new(id, balance)

      account.must_respond_to :id
      account.id.must_equal id

      account.must_respond_to :balance
      account.balance.must_equal balance
    end

    it "Raises an ArgumentError when created with a negative balance" do
      # Note: we haven't talked about procs yet. You can think
      # of them like blocks that sit by themselves.
      # This code checks that, when the proc is executed, it
      # raises an ArgumentError.
      proc {
        Bank::Account.new(1337, -100.0)
      }.must_raise ArgumentError
    end

    it "Can be created with a balance of 0" do
      # If this raises, the test will fail. No 'must's needed!
      Bank::Account.new(1337, 0)
    end
  end

  describe "Account#withdraw" do
    it "Reduces the balance" do
      start_balance = 100.0
      withdrawal_amount = 25.0
      account = Bank::Account.new(1337, start_balance)

      account.withdraw(withdrawal_amount)

      expected_balance = start_balance - withdrawal_amount
      account.balance.must_equal expected_balance
    end

    it "Returns the modified balance" do
      start_balance = 100.0
      withdrawal_amount = 25.0
      account = Bank::Account.new(1337, start_balance)

      updated_balance = account.withdraw(withdrawal_amount)

      expected_balance = start_balance - withdrawal_amount
      updated_balance.must_equal expected_balance
    end

    it "Outputs a warning if the account would go negative" do
      start_balance = 100.0
      withdrawal_amount = 200.0
      account = Bank::Account.new(1337, start_balance)

      # Another proc! This test expects something to be printed
      # to the terminal, using 'must_output'. /.+/ is a regular
      # expression matching one or more characters - as long as
      # anything at all is printed out the test will pass.
      proc {
        account.withdraw(withdrawal_amount)
      }.must_output /.+/
    end

    it "Doesn't modify the balance if the account would go negative" do
      start_balance = 100.0
      withdrawal_amount = 200.0
      account = Bank::Account.new(1337, start_balance)

      updated_balance = account.withdraw(withdrawal_amount)

      # Both the value returned and the balance in the account
      # must be un-modified.
      updated_balance.must_equal start_balance
      account.balance.must_equal start_balance
    end

    it "Allows the balance to go to 0" do
      account = Bank::Account.new(1337, 100.0)
      updated_balance = account.withdraw(account.balance)
      updated_balance.must_equal 0
      account.balance.must_equal 0
    end

    it "Requires a positive withdrawal amount" do
      start_balance = 100.0
      withdrawal_amount = -25.0
      account = Bank::Account.new(1337, start_balance)

      proc {
        account.withdraw(withdrawal_amount)
      }.must_raise ArgumentError
    end
  end

  describe "Account#deposit" do
    it "Increases the balance" do
      start_balance = 100.0
      deposit_amount = 25.0
      account = Bank::Account.new(1337, start_balance)

      account.deposit(deposit_amount)

      expected_balance = start_balance + deposit_amount
      account.balance.must_equal expected_balance
    end

    it "Returns the modified balance" do
      start_balance = 100.0
      deposit_amount = 25.0
      account = Bank::Account.new(1337, start_balance)

      updated_balance = account.deposit(deposit_amount)

      expected_balance = start_balance + deposit_amount
      updated_balance.must_equal expected_balance
    end

    it "Requires a positive deposit amount" do
      start_balance = 100.0
      deposit_amount = -25.0
      account = Bank::Account.new(1337, start_balance)

      proc {
        account.deposit(deposit_amount)
      }.must_raise ArgumentError
    end
  end
end

# describe "Wave 1 - Optional" do
#   describe "Owner#initialize" do
#     it "can be instantiated" do
#       owner = Bank::Owner.new
#       owner.must_be_kind_of Bank::Owner, "Must be an owner"
#     end
#
#     it "can have a name and address" do
#       owner = Bank::Owner.new
#       if owner.name.nil? = false
#         if owner.name.is_a? String
#           true
#         end
#       end
#       # owner.addresss
#     end
#
#     it
#
#   end
# end

# TODO: change 'xdescribe' to 'describe' to run these tests
describe "Wave 2" do

  describe "Account.all" do
    it "Returns an array of all accounts" do
      Bank::Account.read_csv
      # TODO: Your test code here!
      Bank::Account.all.must_be_instance_of Array, "Not an array"
    end

    it "Everything in an array is an account" do
      Bank::Account.read_csv
      Bank::Account.all.each do |account|
        account.must_be_instance_of Bank::Account, "Not an account"
      end
    end

    it "Returns the right number of accounts" do
      Bank::Account.read_csv
      Bank::Account.all.length.must_equal 12
    end

    it "first and last accounts have matching ID and balance" do
      #TW: Sometimes produces errors, why?
      Bank::Account.all.first.id.must_equal 1212
      Bank::Account.all.first.balance.must_equal 1235667
      Bank::Account.all.last.id.must_equal 15156
      Bank::Account.all.last.balance.must_equal 4356772
    end
  end

  describe "Account.find" do
    it "Returns an account that exists" do
      if Bank::Account.all[6].id == 15151
        Bank::Account.find(15151).balance.must_equal 9844567
      end
    end

    it "Can find the first account from the CSV" do
      Bank::Account.find(1212).balance.must_equal 1235667
      Bank::Account.find(1212).open_date.must_equal "1999-03-27 11:30:09 -0800"
    end

    it "Can find the last account from the CSV" do
      Bank::Account.find(15156).balance.must_equal 4356772
      Bank::Account.find(15156).open_date.must_equal "1994-11-17 14:04:56 -0800"
    end

    it "Raises an error for an account that doesn't exist" do
      proc {
          Bank::Account.find(001)
      }.must_raise ArgumentError
    end
  end
end

# Useful checks might include:
#   - Account.all returns an array
#   - Everything in the array is an Account
#   - The number of accounts is correct
#   - The ID and balance of the first and last
#       accounts match what's in the CSV file
# Feel free to split this into multiple tests if needed
