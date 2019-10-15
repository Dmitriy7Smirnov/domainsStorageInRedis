# Тестируем как можно больше кейсов.

defmodule Project.Tests do
  use ExUnit.Case, async: false
  @tempLink1 "https://ya.ru?q=123"
  @tempLink2 "funbox.ru"
  @tempLink3 "https://stackoverflow.com/questions/11828270/how-to-exit-the-vim-editor"
  @tempDomain1 "ya.ru"
  @tempDomain2 "funbox.ru"
  @tempDomain3 "stackoverflow.com"

  setup do
    Process.sleep(1000)
  end

  test "create and get domain" do
    Redix.command(:redix, ["flushall"])
    now = Utils.timestamp()
    Utils.set_domains([@tempDomain1], now)
    result = Utils.get_domains(now - 100, now + 100)
    Redix.command(:redix, ["flushall"])
    assert result === [@tempDomain1]
  end

  test "create and get 2 domains" do
    Redix.command(:redix, ["flushall"])
    now = Utils.timestamp()
    Utils.set_domains([@tempDomain1, @tempDomain2], now)
    result = Utils.get_domains(now - 100, now + 100)
    Redix.command(:redix, ["flushall"])
    assert Enum.sort(result) === Enum.sort([@tempDomain1, @tempDomain2])
  end

  test "create and get 3 domains" do
    Redix.command(:redix, ["flushall"])
    now = Utils.timestamp()
    Utils.set_domains([@tempDomain1, @tempDomain2, @tempDomain3], now)
    result = Utils.get_domains(now - 100, now + 100)
    Redix.command(:redix, ["flushall"])
    assert Enum.sort(result) === Enum.sort([@tempDomain1, @tempDomain2, @tempDomain3])
  end

  test "create and get domains corresponding time 1" do
    Redix.command(:redix, ["flushall"])
    now = Utils.timestamp()
    now1 = now - 200
    now3 = now + 200
    Utils.set_domains([@tempDomain1], now1)
    Utils.set_domains([@tempDomain2], now)
    Utils.set_domains([@tempDomain3], now3)
    result = Utils.get_domains(now - 100, now + 100)
    Redix.command(:redix, ["flushall"])
    assert result === [@tempDomain2]
  end

  test "create and get domains corresponding time 2" do
    Redix.command(:redix, ["flushall"])
    now = Utils.timestamp()
    now1 = now - 50
    now3 = now + 200
    Utils.set_domains([@tempDomain1], now1)
    Utils.set_domains([@tempDomain2], now)
    Utils.set_domains([@tempDomain3], now3)
    result = Utils.get_domains(now - 100, now + 100)
    Redix.command(:redix, ["flushall"])
    assert Enum.sort(result) === Enum.sort([@tempDomain1, @tempDomain2])
  end

  test "create and get domains corresponding time 3" do
    Redix.command(:redix, ["flushall"])
    now = Utils.timestamp()
    now1 = now - 200
    now3 = now + 50
    Utils.set_domains([@tempDomain1], now1)
    Utils.set_domains([@tempDomain2], now)
    Utils.set_domains([@tempDomain3], now3)
    result = Utils.get_domains(now - 100, now + 100)
    Redix.command(:redix, ["flushall"])
    assert Enum.sort(result) === Enum.sort([@tempDomain2, @tempDomain3])
  end

  test "link to domain 1" do
    result = Utils.domain(@tempLink1)
    assert result === {:ok, @tempDomain1}
  end

  test "link to domain 2" do
    result = Utils.domain(@tempLink2)
    assert result === {:ok, @tempDomain2}
  end

  test "link to domain 3" do
    result = Utils.domain(@tempLink3)
    assert result === {:ok, @tempDomain3}
  end
end
