class JsTestServer::Server::Resources::NotFound < JsTestServer::Server::Resources::Resource
  include JsTestServer::Server
  map "*"

  get "/" do
    call
  end

  put "/" do
    call
  end

  post "/" do
    call
  end

  delete "/" do
    call
  end

  def call
    body = Views::NotFound.new(:message => "File #{request.path_info} not found").to_s
    [ 404, { "Content-Type" => "text/html" }, body ]
  end
end