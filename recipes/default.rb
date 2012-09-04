node['graphite']['packages'].each do |p| 
    package p
end

directory node['graphite']['src_dir']

node['graphite']['src'].each do |component, repo|
    log repo
    
    git component do
        repository repo
        action :checkout
        revision node['graphite']['version'] if node['graphite']['version']
        
        destination "#{node['graphite']['src_dir']}/#{component}"
    end
end

node['graphite']['src'].each do |component, repo|
    execute "cd #{node['graphite']['src_dir']}/#{component}; python setup.py install" do
        not_if {node['graphite'][component] == "installed"}
    end
    node.set['graphite'][component] = "installed"
    
end

user node['graphite']['carbon_user']
template "/opt/graphite/conf/carbon.conf" do
    source "carbon.conf.erb"
    variables(:carbon_user => node['graphite']['carbon_user'])
    mode "0644"
end

template "/opt/graphite/conf/storage-schemas.conf" do
    source "storage-schemas.conf.erb"
    mode "0644"
end

template "/opt/graphite/conf/graphite.wsgi" do
    source "graphite.wsgi.erb"
    mode "0644"
end

template "/etc/apache2/sites-available/graphite" do
    source "apache2/graphite.erb"
    mode "0644"
    notifies :restart, 'service[apache2]'

end

link "/etc/apache2/sites-enabled/graphite" do
    to "/etc/apache2/sites-available/graphite"
end

file "/etc/apache2/graphite.htpasswd" do
    content "#{node['graphite_web']['user']}:#{node['graphite_web']['password_htpasswd']}"
end

execute "a2enmod ssl" do
    creates "/etc/apache2/mods-enabled/ssl.conf"
end


service "apache2" do
    action [:start, :enable]
end

# We don't run python manage.py syncdb
# execute "python manage.py syncdb"

cookbook_file "/opt/graphite/storage/graphite.db" do
    source "graphite.db"
    owner 'www-data'
    group 'www-data'
end

directory "/opt/graphite/storage/" do
    owner 'www-data'
end

execute "chown -R www-data /opt/graphite/storage/log"

execute "chown -R #{node['graphite']['carbon_user']} /opt/graphite/storage/whisper/"

svc = "/usr/bin/python /opt/graphite/bin/carbon-cache.py"
template "/etc/init.d/carbon-cache" do
    source "init.d/carbon-cache.erb"
    mode "0755"
    variables(:svc => svc)
end

service "carbon-cache" do
    action [:enable, :start]
end