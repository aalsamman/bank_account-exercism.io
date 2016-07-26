defmodule BankAccount do

  # The BankAccount module should support four calls:
  #
  # open_bank()
  #   Called at the start of each test. Returns an account handle.
  #
  # close_bank(account)
  #   Called at the end of each test.
  #
  # balance(account)
  #   Get the balance of the bank account.
  #
  # update(account, amount)
  #   Increment the balance of the bank account by the given amount.
  #   The amount may be negative for a withdrawal.
  #
  # The initial value of the bank account should be 0.

  @doc """
  defining a struct instead of saving the balance/state inside the process gives the program more
  flexibility for future usages
  """
  defstruct balance: 0

  @doc """
  In the following function, we are using Agent instead of GenServer as with Agent we can easily
  save a state.
  Received account from Agent.start is just a PID number that needs to be stored in order to interact with
  this "account".
  """
  def open_bank() do
    {state, account} = Agent.start(fn -> %BankAccount{} end)
    case state do #It's important to check the status as Agent.start might fail to start
      :ok -> account
      _ -> open_bank
    end
  end

  @doc """
  the balance method will retrieve the state of the agent, which is a struct, then show/return the balance
  """
  def balance(account) do
    state = Agent.get(account, fn(n) -> n end)
    # IO.inspect state
    state.balance
  end

  @doc """
  The following function will get the state of account, do some magic on balance, then update the agent state
  """
  def update(account, amount) do
    state = Agent.get(account, fn(n) -> n end)
    tmp= amount + state.balance
    new = %BankAccount{balance: tmp}
    # Agent.update(account, fn(tmp) -> &(%{&1 | balance: tmp}) end)
    Agent.update(account, fn(_state) -> new end)
  end

end
