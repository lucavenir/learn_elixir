defmodule HandlerTest do
  use ExUnit.Case, async: true

  import Servy.Handler, only: [handle: 1]

  test "GET /wildthings" do
    request = """
    GET /wildthings HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
           HTTP/1.1 200 OK\r
           Content-Type: text/html\r
           Content-Length: 24\r
           \r
           😃 Bears, Lions, Tigers
           """
  end

  test "GET /bears" do
    request = """
    GET /bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 421\r
    \r
    😃<h1>All the bears</h1>

    <ul>
      <li>Brutus - Grizzly</li>
      <li>Iceman - Polar</li>
      <li>Kenai - Grizzly</li>
      <li>Paddington - Brown</li>
      <li>Roscoe - Panda</li>
      <li>Rosie - Black</li>
      <li>Scarface - Grizzly</li>
      <li>Smokey - Black</li>
      <li>Snow - Polar</li>
      <li>Teddy - Brown</li>
    </ul>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /bigfoot" do
    request = """
    GET /bigfoot HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
           HTTP/1.1 404 Not Found\r
           Content-Type: text/html\r
           Content-Length: 28\r
           \r
           😞 /bigfoot route not found
           """
  end

  test "GET /bears/1" do
    request = """
    GET /bears/1 HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 79\r
    \r
    😃<h1>Show Bear</h1>
    <p>
    Is Teddy hibernating? <strong>true</strong>
    </p>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /wildlife" do
    request = """
    GET /wildlife HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
           HTTP/1.1 200 OK\r
           Content-Type: text/html\r
           Content-Length: 24\r
           \r
           😃 Bears, Lions, Tigers
           """
  end

  test "GET /about" do
    request = """
    GET /about HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 335\r
    \r
    😃<h1>Clark's Wildthings Refuge</h1>

    <blockquote>
    When we contemplate the whole globe as one great dewdrop, striped and dotted with continents and islands, flying
    through space with other stars all singing and shining together as one, the whole universe appears as an infinite
    storm of beauty. -- John Muir
    </blockquote>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "POST /bears" do
    request = """
    POST /bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    Content-Type: application/x-www-form-urlencoded\r
    Content-Length: 21\r
    \r
    name=Baloo&type=Brown
    """

    response = handle(request)

    assert response == """
           HTTP/1.1 201 Created\r
           Content-Type: text/html\r
           Content-Length: 36\r
           \r
           😃 created a Brown bear named Baloo
           """
  end

  test "DELETE /bears/:id" do
    request = """
    DELETE /bears/1 HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
           HTTP/1.1 204 No Content\r
           Content-Type: text/html\r
           Content-Length: 18\r
           \r
           😃 bear 1 is gone
           """
  end

  defp remove_whitespace(text) do
    String.replace(text, ~r{\s}, "")
  end
end
