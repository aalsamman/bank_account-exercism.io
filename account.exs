defmodule BankAccount do

  @doc """
  defining a struct instead of saving the balance/state inside the process gives the program more
  flexibility for future usages
  """
  defstruct balance: 0

  @doc """
  In the following function, we are using Agent instead of GenServer as with Agent we can easily
  save a state.
  Received account from Agent.start is just a PID number that needs to be stored in order to interact with
  the specific "account"
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
    state.balance
  end

  @doc """
  The following function will get the state of account, do some magic on balance, then update the agent state
  """
  def update(account, amount) do
    state = Agent.get(account, fn(n) -> n end)
    tmp= amount + state.balance
    new = %BankAccount{balance: tmp}
    Agent.update(account, fn(_state) -> new end)
  end

  @doc """
  close_bank is a simple server stop. Passing the agent pid is the only requirement
  There's no need to check the result as it'll show the reason instead of replying with :ok and log the reason!
  """
  def close_bank(account) do
    Agent.stop(account)
  end

end
