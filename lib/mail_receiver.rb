#!/usr/bin/env ruby
require 'rubygems'
require 'mail'
require 'beanstalk-client'
require 'mongo_mapper'
require File.join(File.dirname(__FILE__), '..', 'app', 'models', 'mail_queue')

MongoMapper.database = 'salesflip_production'

message = $stdin.read
mail = Mail.new(message)

if !mail.to.nil?
  item = MailQueue.create! :mail => mail.to_s, :status => 'New'

  BEANSTALK = Beanstalk::Pool.new(['127.0.0.1:11300'])
  BEANSTALK.yput({
    :type => 'received_email',
    :item => item.id
  })
end
