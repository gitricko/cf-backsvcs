#!/bin/bash
(
    sleep 30
    rabbitmq-plugins enable rabbitmq_management
    rabbitmqctl add_user "rabbit" "rabbit"
    rabbitmqctl set_user_tags rabbit administrator
    rabbitmqctl set_permissions --vhost '/' 'rabbit' '.' '.' '.' 
) & 
rabbitmq-server start 
