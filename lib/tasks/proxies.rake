namespace :proxies do
  desc 'Setup web proxies'
  task :setup, [:proxies] => :environment do |t, args|
    proxies = [args[:proxies]] + args.extras
    Proxy.delete_all
    proxies.each do |proxy|
      Proxy.create! url: proxy
    end
  end
end
