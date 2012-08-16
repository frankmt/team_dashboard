base_path = File.expand_path('../../', __FILE__)

worker_processes 2

preload_app true
timeout 60

listen base_path + '/tmp/unicorn.sock', :backlog => 1024

pid base_path + '/tmp/unicorn.pid'

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.clear_all_connections!
end

after_fork do |server, workder|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
