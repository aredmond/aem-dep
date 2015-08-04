#
# Cookbook Name:: django_deploy
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved


donthasthegoods = true
donthasjava = true
pulljar = true

if donthasthegoods
  bash "apt-get update" do
    user "root"
    group "root"
    code <<-EOC

      apt-get update
      apt-get install -y build-essential
    EOC
  end

  %w(
    vim
    git
  ).each do |pkg|
    package pkg do
  #    options "--enablerepo=epel"
      action :install
    end
  end
end

if donthasjava
  bash "install java" do
    user "root"
    group "root"
    code <<-EOC
      echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list
      echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list

      apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
      apt-get update
      echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
      apt-get install -y oracle-java8-installer ca-certificates
    EOC
  end
end


if pulljar
  #
  #bash "pull_jar" do
  #  user "root"
  #  cwd "/adobe/aem/author"
  #  code <<-EOH
  #    wget 249b6ddfccbfcf0fe3cc-085962300bce973d0aa81bf2a0e9961b.r19.cf1.rackcdn.com/aem-author-4502.jar
  #  EOH
  #  action :nothing
  #  not_if do ::File.exists?('/adobe/aem/author/aem-author-4502.jar') end
  #end

  %w(
    /adobe
    /adobe/aem
    /adobe/aem/author
  ).each do |dirpart|
    directory dirpart do
      owner 'root'
      group 'root'
    #  mode '0755'
      action :create
    #  notifies :run, "bash[pull_jar]", :immediately
    end
  end

  template '/adobe/aem/author/runserver' do
    source 'runserver.erb'
    owner 'root'
    group 'root'
    mode '0775'
  end
end
