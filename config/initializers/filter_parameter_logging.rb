# Be sure to restart your server when you modify this file.
require 'application_record'
require 'membership_application'
require 'membership_application/steps'

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [:password] + MembershipApplication::Steps::FILTER_PARAMS

