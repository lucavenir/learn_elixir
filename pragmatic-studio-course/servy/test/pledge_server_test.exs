defmodule PledgeServerTest do
  use ExUnit.Case

  alias Servy.PledgeServer

  test "caches at most three pledges in its state, and totals their amount" do
    PledgeServer.start()

    PledgeServer.create_pledge("pippo", 1)
    PledgeServer.create_pledge("pluto", 2)
    PledgeServer.create_pledge("paperino", 3)
    PledgeServer.create_pledge("topolino", 4)
    PledgeServer.create_pledge("paperone", 5)
    PledgeServer.create_pledge("paperoga", 6)
    PledgeServer.create_pledge("paperina", 7)

    assert PledgeServer.recent_pledges() == [
             {"paperina", 7},
             {"paperoga", 6},
             {"paperone", 5}
           ]

    assert PledgeServer.total_pledged() == 18
  end
end
